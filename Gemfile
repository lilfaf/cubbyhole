source 'https://rubygems.org'

gem 'rails', '4.1.1'

# Web server
gem 'thin', '~> 1.6.2'
gem 'unicorn'
gem 'foreman'

# Deployement
gem 'capistrano'
gem 'capistrano-rvm'
gem 'capistrano-bundler'
gem 'capistrano-rails'

# MySQL adapter
gem 'mysql2'

# Tree data structure
gem 'awesome_nested_set', '~> 3.0.0.rc.3'

# Authentication and OAuth
gem 'devise', '~> 3.2.2'
gem 'doorkeeper', '~> 1.0.0'

# Foundation
gem 'foundation-rails'
gem 'foundation_rails_helper', github: 'dsandstrom/foundation_rails_helper', branch: 'fix-flash-notice'

# Payment
gem 'activemerchant', '~> 1.42.4'

# API
gem 'active_model_serializers', '~> 0.9.0.alpha1'

# Admin
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'chartkick'
gem 'groupdate'

# Data generation
gem 'faker'

# Assets
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'foundation-icons-sass-rails'
gem 'bower-rails', '~> 0.7.2'
gem 'gon', '~> 5.0.4'
gem 'select2-rails'

# Uploads
gem 'unf'
gem 'fog', '~> 1.21.0'
gem 'carrierwave', '~> 0.10.0'
gem 'rmagick', require: 'RMagick'
gem 's3_direct_upload'

# Background jobs
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'

# Web sockets
gem 'websocket-rails'

# Common
gem 'dotenv-rails', groups: [:development, :test]
gem 'coveralls', require: false

# Monitoring
gem 'sentry-raven', :git => 'http://github.com/getsentry/raven-ruby.git'

group :test do
  gem 'minitest'
  gem 'rspec-rails', '~> 2.14.1'
  gem 'factory_girl_rails', '~> 4.4.1'
  gem 'database_cleaner', '~> 1.2.0'
  gem 'shoulda-matchers', '~> 2.5.0'
  gem 'capybara', '~> 2.2.1'
  gem 'oauth2', '~> 0.9.3'
  gem 'poltergeist', '~> 1.5.0'
end

group :development do
  gem 'quiet_assets'
  gem 'meta_request'
  gem 'better_errors'
  gem 'binding_of_caller'
end
