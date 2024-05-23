# 開発構築
`git clone`して`docker compose build`
LINE DevelopersからLINEログインを有効にして
`LINE_CHANNEL_ID`と`LINE_CHANNEL_SECRET`を.envに設定する。

# 開発環境
- [chromeの拡張機能](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei//go)を使えばhot reloadになる
- ドメイン/ポート`http://localhost:3000`

## rubocop
`bundle exec rubocop -c .rubocop.yml --require rubocop-airbnb -a`  
もしくはwebコンテナ内で  
`make rubocop`  

## rspec
`RAILS_ENV=test bundle exec rspec`  
もしくはwebコンテナ内で  
`make rspec`  

## デプロイ(fly.io)
`flyctl deploy`  
画面を開くには  
`flyctl open`