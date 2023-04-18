ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require_relative "custom_helper"

# require "minitest/reporters"
# Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)

  fixtures :all

  # make_my_diffs_pretty!
end

class ActionDispatch::IntegrationTest
  include CustomHelper
end
