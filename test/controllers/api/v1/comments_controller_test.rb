require "test_helper"

class Api::V1::CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
    @token = authenticate! @user
    @project = projects(:one)
    @task = tasks(:one)
  end

  ### success

  test "GET index" do
    get api_v1_project_task_comments_path(@project, @task),
        headers: {Authorization: "HS256 #{@token}"}

    assert_response :ok
    assert_matches_json_schema response, "comments/index"
  end

  test "POST comments" do
    new_comment = "example"

    assert_difference("Comment.count") do
      post api_v1_project_task_comments_path(@project, @task),
           headers: {Authorization: "HS256 #{@token}"},
           params: {content: new_comment}
    end

    assert_response :created
    assert_equal 2, @task.reload.comments.count
  end

  test "DELETE comment" do
    comment = comments(:one)

    assert_difference("Comment.count", -1) do
      delete api_v1_project_task_comment_path(@project, @task, comment),
             headers: {Authorization: "HS256 #{@token}"}
    end

    assert_response :ok
  end

  ### fail

  test "GET index fail auth" do
    get api_v1_project_task_comments_path(@project, @task)

    assert_response :unauthorized
    assert_equal t("user.errors.login_first"), parse_resp["error"]
  end

  test "GET index fail missing" do
    get api_v1_project_task_comments_path(@project, @task.id + 123),
        headers: {Authorization: "HS256 #{@token}"}

    assert_response :not_found
  end

  test "POST comments fail auth" do
    new_comment = "example"

    assert_no_difference("Comment.count") do
      post api_v1_project_task_comments_path(@project, @task),
           params: {data: {content: new_comment}}
    end

    assert_response :unauthorized
  end

  test "DELETE comment fail auth" do
    comment = comments(:one)

    assert_no_difference("Comment.count") do
      delete api_v1_project_task_comment_path(@project, @task, comment)
    end

    assert_response :unauthorized
  end
end
