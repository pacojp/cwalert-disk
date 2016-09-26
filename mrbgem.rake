MRuby::Gem::Specification.new('cwalert-disk') do |spec|
  spec.license = 'MIT'
  spec.author  = 'MRuby Developer'
  spec.summary = 'cwalert-disk'
  spec.bins    = ['cwalert-disk']

  spec.add_dependency 'mruby-print', :core => 'mruby-print'
  spec.add_dependency 'mruby-mtest', :mgem => 'mruby-mtest'
end
