require "test_helper"

class Api::V1::TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
    @token = authenticate! @user
    @project = projects(:one)
    @task = tasks(:one)
  end

  ### success

  test "GET index" do
    get api_v1_project_tasks_path(@project),
        headers: {Authorization: "HS256 #{@token}"}

    assert_response :ok
    assert_matches_json_schema response, "tasks/index"
  end

  test "SHOW task" do
    get api_v1_project_task_path(@project, @task),
        headers: {Authorization: "HS256 #{@token}"}

    assert_response :ok
    assert_matches_json_schema response, "task"
  end

  test "POST tasks" do
    assert_difference("Task.count") do
      post api_v1_project_tasks_path(@project),
           params: {data: {title: "new"}},
           headers: {Authorization: "HS256 #{@token}"}
    end

    assert_response :created
    assert_equal 2, @project.tasks.count
  end

  test "PATCH task" do
    new_title = "updated"

    put api_v1_project_task_path(@project, @task),
        params: {data: {title: new_title}},
        headers: {Authorization: "HS256 #{@token}"}

    assert_response :ok
    assert_equal new_title, @task.reload.title
  end

  test "DELETE task" do
    assert_difference("Task.count", -1) do
      delete api_v1_project_task_path(@project, @task),
             headers: {Authorization: "HS256 #{@token}"}
    end

    assert_response :ok
  end

  test "TOGGLE task" do
    post toggle_api_v1_project_task_path(@project, @task),
         headers: {Authorization: "HS256 #{@token}"}

    assert_response :ok
    assert @task.reload.completed
  end

  test "UP task" do
    new_task = Task.create(title: "new task", project: @project)
    p1, p2 = @task.position, new_task.reload.position

    post up_api_v1_project_task_path(@project, new_task),
         headers: {Authorization: "HS256 #{@token}"}

    assert_response :ok
    assert_equal p2, @task.reload.position
    assert_equal p1, new_task.reload.position
  end

  test "DOWN task" do
    new_task = Task.create(title: "new task", project: @project)
    p1, p2 = @task.position, new_task.reload.position

    post down_api_v1_project_task_path(@project, @task),
         headers: {Authorization: "HS256 #{@token}"}

    assert_response :ok
    assert_equal p2, @task.reload.position
    assert_equal p1, new_task.reload.position
  end

  ### fail

  test "GET index fail no auth" do
    get api_v1_project_tasks_path(@project)

    assert_response :unauthorized
    assert_equal t("user.errors.login_first"), parse_resp["error"]
  end

  test "SHOW task fail no auth" do
    get api_v1_project_task_path(@project, @task)

    assert_response :unauthorized
  end

  test "SHOW task fail not found" do
    get api_v1_project_task_path(@project, @task.id + 123),
        headers: {"Authorization" => "HS256 #{@token}"}

    assert_response :not_found
    assert_matches_json_schema response, "error"
  end

  test "POST tasks fail no auth" do
    assert_no_difference("Task.count") do
      post api_v1_project_tasks_path(@project), params: {data: {title: "new"}}
    end

    assert_response :unauthorized
  end

  test "POST tasks fail already exists" do
    post api_v1_project_tasks_path(@project),
         params: {data: {title: @task.title}},
         headers: {Authorization: "HS256 #{@token}"}

    assert_response :unprocessable_entity
    assert_matches_json_schema response, "error"
  end

  test "PATCH task fail no auth" do
    patch api_v1_project_task_path(@project, @task),
          params: {data: {title: "updated"}}

    assert_response :unauthorized
  end

  test "DELETE task fail no auth" do
    assert_no_difference("Task.count") do
      delete api_v1_project_task_path(@project, @task)
    end

    assert_response :unauthorized
  end

  test "TOGGLE task fail no auth" do
    post toggle_api_v1_project_task_path(@project, @task)

    assert_response :unauthorized
  end

  test "UP and DOWN task fail no auth" do
    post up_api_v1_project_task_path(@project, @task)
    assert_response :unauthorized

    post down_api_v1_project_task_path(@project, @task)
    assert_response :unauthorized
  end
end
