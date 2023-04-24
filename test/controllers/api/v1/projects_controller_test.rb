require "test_helper"

class Api::V1::ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
    @token = authenticate! @user
    @project = projects(:one)
  end

  ### success

  test "GET index" do
    get api_v1_projects_path,
        headers: {"Authorization": "HS256 #{@token}"}

    assert_response :ok
    assert_matches_json_schema response, "projects/index"
  end

  test "GET show" do
    get api_v1_project_path(@project),
        headers: {"Authorization": "HS256 #{@token}"}

    assert_response :ok
    assert_equal @project.id, parse_resp[:data][:id]
    assert_matches_json_schema response, "project"
  end

  test "POST create" do
    assert_difference("Project.count") do
      post api_v1_projects_path,
           headers: {"Authorization": "HS256 #{@token}"},
           params: {data: {name: "created"}}
    end

    assert_response :created
    assert_equal 2, @user.projects.count
  end

  test "PATCH update" do
    new_name = "updated"

    patch api_v1_project_path(@project),
          headers: {"Authorization": "HS256 #{@token}"},
          params: {data: {name: new_name}}

    assert_response :ok
    assert_equal new_name, @project.reload.name
  end

  test "DELETE destroy" do
    assert_difference("Project.count", -1) do
      delete api_v1_project_path(@project),
             headers: {"Authorization": "HS256 #{@token}"}
    end

    assert_response :ok
  end

  test "DELETE destroy dependent destroy" do
    count = @project.tasks.count

    assert_difference("Task.count", -count) do
      delete api_v1_project_path(@project),
             headers: {"Authorization": "HS256 #{@token}"}
    end
  end

  ### fail

  test "GET index fail no auth" do
    get api_v1_projects_path

    assert_response 401
    assert_equal t("user.errors.login_first"), parse_resp["error"]
  end

  test "GET show fail no auth" do
    get api_v1_project_path(@project)

    assert_response 401
    assert_equal t("user.errors.login_first"), parse_resp["error"]
  end

  test "POST create fail no auth" do
    post api_v1_projects_path, params: {data: {name: "example"}}

    assert_response 401
    assert_equal t("user.errors.login_first"), parse_resp["error"]
  end

  test "POST create fail already exists" do
    post api_v1_projects_path,
          headers: {"Authorization": "HS256 #{@token}"},
          params: {data: {name: @project.name}}

    assert_response 422
    assert_matches_json_schema response, "error"
  end

  test "PATCH update fail no auth" do
    patch api_v1_project_path(@project), params: {data: {name: "edited"}}

    assert_response 401
    assert_equal t("user.errors.login_first"), parse_resp["error"]
  end

  test "DELETE destroy fail no auth" do
    delete api_v1_project_path(@project)

    assert_response 401
    assert_equal t("user.errors.login_first"), parse_resp["error"]
  end
end
