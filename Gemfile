source :rubygems

gem 'sinatra'
gem 'sinatra-contrib'
gem 'foreman'
gem 'data_mapper'

group :development, :test do
  gem 'sqlite3'
  gem 'dm-sqlite-adapter'
end

group :production do
  gem 'pg'
  gem 'dm-postgres-adapter'
end

group :test do
  gem 'rspec'
  gem 'rack-test', require: 'rack/test'
end

