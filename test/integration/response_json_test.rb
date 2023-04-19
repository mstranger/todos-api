require "test_helper"

class TasksTest < ActionDispatch::IntegrationTest
  setup do
    @token = authenticate! users(:john)
  end

  test "GET task" do
    task = tasks(:one)
    get api_v1_task_path(task), headers: {"Authorization": "HS256 #{@token}"}

    assert_equal 200, response.status
    assert_matches_json_schema response, "task"
  end

  test "GET tasks" do
    get api_v1_tasks_path, headers: {"Authorization": "HS256 #{@token}"}

    assert_equal 200, response.status
    assert_matches_json_schema response, "tasks/index"
  end

  test "POST login" do
    user = users(:john)
    post auth_login_path, params: {email: user.email, password: "password"}

    assert_equal 200, response.status
    assert_matches_json_schema response, "users/login"
  end

  test "GET me" do
    token = authenticate! users(:john)
    get me_path, headers: {"Authorization": "HS256 #{token}"}

    assert_equal 200, response.status
    assert_matches_json_schema response, "users/me"
  end
end
