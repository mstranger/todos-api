source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "rails", "~> 7.0"
gem "pg", "~> 1.5"
gem "puma", "~> 5.0"
gem "jbuilder"
gem "aws-sdk-s3", "~> 1"

gem "bcrypt", "~> 3.1.7"
gem "jwt", "~> 2.7"

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "bootsnap", require: false

gem "apipie-rails", "~> 0.9.3"

gem "rack-cors"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "bullet", "~> 7.0"
end

group :development do
  gem "annotate", require: false
  gem "rubocop-rails", "~> 2.19", require: false
  gem "rubocop-performance", "~> 1.17", require: false
  gem "database_consistency", require: false
  gem "brakeman", require: false
  gem "bundler-audit", require: false
end

group :test do
  gem "minitest-reporters"
  gem "json_matchers"
  gem "simplecov", require: false
end
