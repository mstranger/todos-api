require "test_helper"

class Api::V1::TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
    @token = authenticate! @user
    @project = projects(:one)
    @task = tasks(:one)
  end

  ### success

  # TODO: json schema test

  test "GET index" do
    get api_v1_project_tasks_path(@project),
        headers: { "Authorization" => "HS256 #{@token}" }

    assert_response :ok
    # assert_matches_json_schema response, "task"
  end

  test "SHOW task" do
    get api_v1_project_task_path(@project, @task),
        headers: { "Authorization" => "HS256 #{@token}" }

    assert_response :ok
    # assert_matches_json_schema response, "task"
  end

  test "POST tasks" do
    assert_difference("Task.count") do
      post api_v1_project_tasks_path(@project),
        params: {data: {title: "new"}},
        headers: {"Authorization": "HS256 #{@token}"}
    end

    assert_response :created
    assert_equal 2, @project.tasks.count
  end

  test "PATCH task" do
    new_title = "updated"

    put api_v1_project_task_path(@project, @task),
      params: {data: {title: new_title}},
      headers: {"Authorization": "HS256 #{@token}"}

    assert_response :ok
    assert_equal new_title, @task.reload.title
  end

  test "DELETE task" do
    assert_difference("Task.count", -1) do
      delete api_v1_project_task_path(@project, @task),
             headers: {"Authorization": "HS256 #{@token}"}
    end

    assert_response :ok
  end

  test "TOGGLE task" do
    post toggle_api_v1_project_task_path(@project, @task),
         headers: {"Authorization": "HS256 #{@token}"}

    assert_response :ok
    assert @task.reload.completed
  end

  ### fail

  test "GET index fail" do
    get api_v1_project_tasks_path(@project)

    assert_response :unauthorized
    assert_equal t("user.errors.login_first"), parse_resp["error"]
  end

  test "SHOW task fail" do
    get api_v1_project_task_path(@project, @task)

    assert_response :unauthorized
  end

  test "POST tasks fail" do
    assert_no_difference("Task.count") do
      post api_v1_project_tasks_path(@project), params: {data: {title: "new task"}}
    end

    assert_response :unauthorized
  end

  test "PATCH task fail" do
    patch api_v1_project_task_path(@project, @task),
          params: {data: {title: "updated"}}

    assert_response :unauthorized
  end

  test "DELETE task fail" do
    assert_no_difference("Task.count") do
      delete api_v1_project_task_path(@project, @task)
    end

    assert_response :unauthorized
  end

  test "TOGGLE task fail" do
    post toggle_api_v1_project_task_path(@project, @task)

    assert_response :unauthorized
  end
end
