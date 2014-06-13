source 'https://rubygems.org'

## Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Sass version of bootstrap
gem 'bootstrap-sass'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Makes $(document).ready() work with turbolinks
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# For haml syntax
gem 'haml'

# For creating haml files when performing scaffold
gem 'haml-rails'

# Forms made easy
gem 'simple_form'

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.2'

# For pagination
gem 'will_paginate', '~> 3.0'

# For queing processes to do in background
gem 'sidekiq'

# For monitoring sidekiq queues
gem 'sinatra', require: false
gem 'slim'

#For admin users
gem 'devise'

# For authorizations
gem 'cancan'


group :development do
  # Use sqlite3 as the database for development
  gem 'sqlite3'

  # Better looking error page
  gem 'better_errors'

  # Console in error page
  gem 'binding_of_caller'


end

group :development, :test do
  # For testing
  gem 'rspec-rails'
  gem 'rspec'

    # Api documentation
  gem 'rspec_api_documentation'
  gem "apitome"

  # To create test objects
  gem 'factory_girl_rails'

  # To simulate users actions in testing
  gem 'capybara' 

end

group :production, :staging do
  # For postgres
  gem 'pg'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

