# 開発環境
- [chromeの拡張機能](https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei//go)を使えばhot reloadになる
- http環境は`http://localhost:3000`
- https環境は`https://localhost:3443`

## rubocop
`bundle exec rubocop -c .rubocop.yml --require rubocop-airbnb -a`
もしくはwebコンテナ内で
`make rubocop`

## rspec
`RAILS_ENV=test bundle exec rspec`
もしくはwebコンテナ内で
`make rspec`