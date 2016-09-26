## 概要

「ディスクサイズアラートをチャットワークにあげたい」な要求により作成した個人的最低限の実装 by mruby

## アンニュイな点

* マウントポイントが / のみ対応
* centos6系（Amazon Linux含む）のみ確認
* docker、、、なにそれ、うまいの？（クロスコンパイル系は一旦コメントアウト）

## install

``` bash
git clone https://github.com/pacojp/cwalert-disk.git
cd cwalert-disk/
rake
./mruby/bin/cwalert-disk YOUR_CONFIG_FILE_PATH
```

## config file format

``` json
{
  "hostname": "YOUR_HOST_NAME",
  "warning":   70,
  "critical":  85,
  "warning-hours": [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19],
  "cw": {
    "room-id":  "CW_ROOM_ID",
    "token":    "CW_TOKEN",
    "users-to": ["CW_USER_ID_A_TO_ALERT", "CW_USER_ID_B_TO_ALERT"]
  }
}
```
optionals

* hostname
* warning-hours
* users-to

## usage

誰かが使うとは思っていないけど、、一応自身の環境できちんと動作確認すること（cron設定のレベルまで）。レポートオプションも付けてないので（プログラム自体はキチンと動いていますよ報告）、事前に動作確認をきちんと取らないとひどい目に合いますよ。

### warning-hours

ワーニングごときで夜起きたくねぇよ対応

## 言い訳

もっと機能を増やそうと思えば増やせるが、本プログラムはあくまで補助++の位置付けということで単機能にしてます。

個人的にはサーバのステータス管理はinfluxDB + grafanaがおすすめです
