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

  # TODO: check also deleting coresponding tasks

  test "DELETE destroy" do
    assert_difference("Project.count", -1) do
      delete api_v1_project_path(@project),
             headers: {"Authorization": "HS256 #{@token}"}
    end

    assert_response :ok
  end

  ### fail

  test "GET index fail" do
    get api_v1_projects_path

    assert_response 401
    assert_equal t("user.errors.login_first"), parse_resp["error"]
  end

  test "GET show fail" do
    get api_v1_project_path(@project)

    assert_response 401
    assert_equal t("user.errors.login_first"), parse_resp["error"]
  end

  test "POST create fail" do
    post api_v1_projects_path, params: {data: {name: "example"}}

    assert_response 401
    assert_equal t("user.errors.login_first"), parse_resp["error"]
  end

  test "PATCH update fail" do
    patch api_v1_project_path(@project), params: {data: {name: "edited"}}

    assert_response 401
    assert_equal t("user.errors.login_first"), parse_resp["error"]
  end

  test "DELETE destroy fail" do
    delete api_v1_project_path(@project)

    assert_response 401
    assert_equal t("user.errors.login_first"), parse_resp["error"]
  end
end
