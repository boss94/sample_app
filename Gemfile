source 'https://rubygems.org'
ruby "1.9.3"

gem 'rails', '3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'rails-i18n'
gem 'beautiful_scaffold', '0.2.5'

# heroku deployment
gem 'heroku'
group :test do
	gem 'sqlite3'
end
group :development, :production do
	gem 'pg'
	gem 'thin'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails'
end

gem 'jquery-rails'
gem "flexslider", "~> 2.0.2"

group :development do
  gem 'rspec-rails'
  #gem 'ruby-debug19', :require => 'ruby-debug'
  gem "debugger"
end

group :test do
  gem 'rspec'
  gem 'webrat'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

gem 'carrierwave'
gem 'cloudinary'

gem "will_paginate"
gem "ransack"
gem "prawn", "1.0.0.rc1"
gem "RedCloth"
gem "bb-ruby"
gem "bluecloth"
gem "rdiscount"
gem "sanitize"