require "test_helper"

class ProjectsWithPermitionsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
    @token = authenticate! @user
    @project = projects(:one)
  end
end
