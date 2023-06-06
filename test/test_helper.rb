require "simplecov"
SimpleCov.start("rails") if ENV["COVERAGE"]

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require_relative "custom_helper"

# require "minitest/reporters"
# Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require "json_matchers/minitest/assertions"

JsonMatchers.schema_root = "test/support/api/schemas"
Minitest::Test.include(JsonMatchers::Minitest::Assertions)

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)

  fixtures :all

  # make_my_diffs_pretty!
end

class ActionDispatch::IntegrationTest
  include CustomHelper
end
