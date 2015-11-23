source 'https://rubygems.org'
ruby '2.1.2'

gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bcrypt'
gem 'fabrication'
gem 'faker'
gem 'figaro'
gem 'sidekiq'
gem 'unicorn'
gem 'sentry-raven'
gem 'carrierwave'
gem 'carrierwave-aws'
gem 'mini_magick'
gem 'stripe'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers', require: false
  gem 'capybara'
  gem 'capybara-email'
  gem 'launchy'
  gem 'vcr', '2.9.3'
  gem 'webmock'
  gem 'selenium-webdriver'
end

group :production, :staging do
  gem 'rails_12factor'
end
