source 'https://rubygems.org'

gem 'rails',        '~> 5.1.6'
gem 'rails-i18n' # 日本語化
gem 'bcrypt' # has_secure_passwordを使ってパスワードをハッシュ化
gem 'faker' # 実際に存在していそうな名前を生成
gem 'bootstrap-sass' # bootstrap
gem 'will_paginate' # ページネーション
gem 'bootstrap-will_paginate' # ページネーションにbootstrapを適用
gem 'puma',         '~> 3.7'
gem 'sass-rails',   '~> 5.0'
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks',   '~> 5'
gem 'jbuilder',     '~> 2.5'
gem 'rounding' # floor_to(xx.minutes) 時刻をxx単位に切り捨て
gem 'roo' # Excel, CSV, OpenOffice, GoogleSpreadSheetを開くことが可能
gem 'enum' # enumメソッドを使える
gem 'enum_help' # enumメソッドの日本語化
gem 'tod' # Tod::TimeOfDayクラスを用いて、時刻だけのオブジェクトを扱える。

group :development, :test do
  gem 'sqlite3'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Herokuへデプロイするときに復活させる。
# group :production do
#   gem 'pg', '0.20.0'
# end

# Windows環境ではtzinfo-dataというgemを含める必要があります
# Mac環境でもこのままでOKです
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]