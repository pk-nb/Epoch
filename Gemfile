source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.5'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 4'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]

gem 'capistrano', '~> 3.1.0'
gem 'capistrano-bundler', '~> 1.1.2'
gem 'capistrano-rails', '~> 1.1.1'
gem 'capistrano-rbenv', github: 'capistrano/rbenv'


gem "slim"
gem "slim-rails"
gem "redcarpet"
gem "normalize-rails"
gem "simple_form"
gem "bcrypt", "~> 3.1.7"
gem "foreigner"
group :development do
  gem "better_errors"
  gem "quiet_assets"
  gem "binding_of_caller"
  gem "html2slim"
  gem "rb-fsevent", group: :osx
  gem "guard"
  gem "guard-livereload"
  gem "guard-rails"
end

group :test, :development do
  gem "pry"
  gem "rspec-rails", "~> 2.14.2"
  gem "factory_girl_rails"
end

group :test do
  gem "capybara"
  gem "shoulda-matchers"
  gem "launchy", require: false
end

group :assets do
  gem "compass-rails"
end

group :production do
  gem 'rails_12factor'
end
