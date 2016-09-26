class Checker
  attr_accessor :hostname, :warning, :critical, :warning_hours,
    :room_id, :token, :users_to

  def initialize(config)
    self.hostname = config["hostname"] || `hostname`.strip
    self.warning  = config["warning"].to_i
    self.critical = config["critical"].to_i
    self.warning_hours = config["warning-hours"] || []
    self.room_id  = config["cw"]["room-id"]
    self.token    = config["cw"]["token"]
    self.users_to = config["cw"]["users-to"] || []
  end

  def check
    # only centos, amazonlinux checked!
    state = :normal
    if `df | grep " /$"`.split(" ")[-2] =~ /(\d+)%/
      usage = $1.to_i
      usage > warning  && state = :warning
      usage > critical && state = :critical
      proceed_by_state state, usage
    else
      "disk size chekck format error(not your fault)"
    end
  end

  def proceed_by_state(state, usage)
    return if state == :normal
    return if state == :warning && !warning_hours.include?(Time.now.hour)
    to_cw ";( disk usage #{state}", "#{state}! disk usage is #{usage}%"
  end

  def to_cw(title, message)
    tos = users_to.map{ |u| "[To:#{u}]" }.join("\n")
    tos += "\n" if tos.size > 0
    message = %|[info][title][#{hostname}] #{title}[/title]#{message}[/info]|
    `curl -s -S -X POST -H "X-ChatWorkToken: #{token}" -k -d "body=#{tos}#{message}" "https://api.chatwork.com/v1/rooms/#{room_id}/messages"`
  end
end

def usage
  "cwalert-disk CONFIG_FILE"
end

def __main__(argv)
  if argv.size != 2
    usage
    return
  end

  case argv[1]
  when "version"
    puts "v#{CwalertDisk::VERSION}"
  else
    config_file = argv[1]
    unless File.exist?(config_file)
      usage
      return
    end
    j = File.read(config_file)
    Checker.new(JSON.parse(j)).check
  end
end
