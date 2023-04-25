require "test_helper"

class ProjectsWithPermitionsTest < ActionDispatch::IntegrationTest
  setup do
    @john = users(:john)
    @jtoken = authenticate! @john
    @jproject = projects(:one)
    @mproject = projects(:two)
    @jtask = tasks(:one)
    @mtask = tasks(:two)
    @jcomment = comments(:one)
    @mcomment = comments(:two)
  end

  test "list comments only for given task" do
    get api_v1_project_task_comments_path(@jproject, @jtask),
        headers: { "Authorization" => "HS256 #{@jtoken}" }

    assert_includes response.body, @jcomment.content
    refute_includes response.body, @mcomment.content
  end

  test "list comments only for its author" do
    get api_v1_project_task_comments_path(@mproject, @mtask),
        headers: { "Authorization" => "HS256 #{@jtoken}" }

    assert_response :forbidden
    assert_equal t("user.errors.not_permitted"), response.body
  end

  test "can't add comment in someone else's comment" do
    assert_no_difference "Comment.count" do
      post api_v1_project_task_comments_path(@mproject, @mtask),
           headers: { "Authorization" => "HS256 #{@jtoken}" },
           params: {data: {content: "awesome"}}
    end

    assert_response :forbidden
    assert_equal t("project.errors.not_permitted"), response.body
  end

  test "can't delete someone else's comment" do
    comment = comments(:two)

    assert_no_difference "Comment.count"  do
      delete api_v1_project_task_comment_path(@mproject, @mtask, comment),
             headers: { "Authorization" => "HS256 #{@jtoken}" }
    end

    assert_no_difference "Comment.count", "Comment in other task cannot be deleted" do
      delete api_v1_project_task_comment_path(@jproject, @jtask, comment),
             headers: { "Authorization" => "HS256 #{@jtoken}" }
    end

    assert_response :forbidden
    assert_equal t("project.errors.not_permitted"), response.body
  end
end
