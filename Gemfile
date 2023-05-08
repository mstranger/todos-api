source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "rails", "~> 7.0"
# gem "sqlite3", "~> 1.4"
gem "pg", "~> 1.5"
gem "puma", "~> 5.0"
gem "jbuilder"

# gem "redis", "~> 4.0"
# gem "kredis"

gem "bcrypt", "~> 3.1.7"
gem "jwt", "~> 2.7"

# gem "devise_token_auth", "~> 1.2"

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

gem "apipie-rails", "~> 0.9.3"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "bullet", "~> 7.0"
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  gem "annotate", require: false
  gem "rubocop-rails", "~> 2.19", require: false
  gem "rubocop-performance", "~> 1.17", require: false
  gem "database_consistency", require: false
  gem "brakeman", require: false
end

group :test do
  gem "minitest-reporters"
  gem "json_matchers"
  gem "simplecov", require: false
end
