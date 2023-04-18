require "test_helper"

class Api::V1::TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
    @token = authenticate! @user
  end

  # all tasks
  test "GET index success" do
    get api_v1_tasks_path, headers: { "Authorization" => "HS256 #{@token}" }

    assert_equal 200, response.status
    assert_includes response.body, tasks(:one).title
    refute_includes response.body, tasks(:two).title
  end

  test "GET index fail" do
    get api_v1_tasks_path

    assert_equal 401, response.status
    assert_equal t("user.errors.login_first"), parse_resp["error"]
  end

  # show one task info
  test "SHOW task success" do
    task = tasks(:one)
    get api_v1_task_path(task), headers: { "Authorization" => "HS256 #{@token}" }

    assert_equal 200, response.status
  end

  test "SHOW task fail" do
    task = tasks(:one)
    get api_v1_task_path(task)

    assert_equal 401, response.status
  end

  test "SHOW someone else's task fail" do
    task = tasks(:two)
    get api_v1_task_path(task), headers: { "Authorization" => "HS256 #{@token}" }

    assert_equal 401, response.status
    assert_equal t("user.errors.not_permitted"), response.body
  end

  # create task
  test "POST tasks success" do
    assert_difference("Task.count") do
      post api_v1_tasks_path,
        params: {data: {title: "new task"}},
        headers: {"Authorization": "HS256 #{@token}"}
    end

    assert_equal 201, response.status
    assert_equal 2, @user.tasks.count
  end

  test "POST tasks fail" do
    assert_no_difference("Task.count") do
      post api_v1_tasks_path, params: {data: {title: "new task"}}
    end

    assert_equal 401, response.status
  end

  # udpate task
  test "PATCH task success" do
    task = tasks(:one)
    new_title = "updated"

    put api_v1_task_path(task),
      params: {data: {title: new_title}},
      headers: {"Authorization": "HS256 #{@token}"}

    assert_equal 200, response.status
    assert_equal new_title, task.reload.title
  end

  test "PATCH task fail" do
    task = tasks(:one)
    new_title = "updated"

    put api_v1_task_path(task), params: {data: {title: new_title}}

    assert_equal 401, response.status
  end

  test "PATCH someone else's task fail" do
    task = tasks(:two)
    new_title = "updated"

    put api_v1_task_path(task),
      params: {data: {title: new_title}},
      headers: {"Authorization": "HS256 #{@token}"}

    assert_equal 401, response.status
    assert_equal t("user.errors.not_permitted"), response.body
    refute_equal new_title, task.reload.title
  end

  # delete task
  test "DELETE task success" do
    task = tasks(:one)

    assert_difference("Task.count", -1) do
      delete api_v1_task_path(task), headers: {"Authorization": "HS256 #{@token}"}
    end

    assert_equal 200, response.status
  end

  test "DELETE task fail" do
    task = tasks(:one)

    assert_no_difference("Task.count") do
      delete api_v1_task_path(task)
    end

    assert_equal 401, response.status
  end

  test "DELETE someone else's task fail" do
    task = tasks(:one)
    token = authenticate! users(:mike)

    assert_no_difference("Task.count") do
      delete api_v1_task_path(task), headers: {"Authorization": "HS256 #{token}"}
    end

    assert_equal 401, response.status
    assert_equal t("user.errors.not_permitted"), response.body
  end

  # toggle completed status
  test "TOGGLE task success" do
    task = tasks(:one)

    post toggle_api_v1_task_path(task), headers: {"Authorization": "HS256 #{@token}"}

    assert_equal 200, response.status
    assert task.reload.completed
  end

  test "TOGGLE task fail" do
    task = tasks(:one)

    post toggle_api_v1_task_path(task)
    assert_equal 401, response.status

    task = tasks(:two)
    post toggle_api_v1_task_path(task), headers: {"Authorization": "HS256 #{@token}"}

    assert_equal 401, response.status
    refute task.reload.completed
  end
end
