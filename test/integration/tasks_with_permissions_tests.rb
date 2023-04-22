require "test_helper"

class ProjectsWithPermitionsTest < ActionDispatch::IntegrationTest
  setup do
    @john = users(:john)
    @jtoken = authenticate! @john
    @jproject = projects(:one)
    @mproject = projects(:two)
    @jtask = tasks(:one)
    @mtask = tasks(:two)
  end

  test "list tasks only for given project" do
    get api_v1_project_tasks_path(@jproject),
        headers: { "Authorization" => "HS256 #{@jtoken}" }

    assert_includes response.body, @jtask.title
    refute_includes response.body, @mtask.title
  end

  test "list tasks only for its author" do
    get api_v1_project_tasks_path(@mproject),
        headers: { "Authorization" => "HS256 #{@jtoken}" }

    assert_response :forbidden
    assert_equal t("user.errors.not_permitted"), response.body
  end

  test "can't show other user's tasks" do
    get api_v1_project_task_path(@mproject, @mtask),
        headers: { "Authorization" => "HS256 #{@jtoken}" }

    assert_response :forbidden
    assert_equal t("project.errors.not_permitted"), response.body
  end

  test "can't create task in someone else's project" do
    assert_no_difference("Task.count") do
      post api_v1_project_tasks_path(@mproject),
           headers: { "Authorization" => "HS256 #{@jtoken}" },
           params: {data: {title: "created"}}
    end

    assert_response :forbidden
    assert_equal t("project.errors.not_permitted"), response.body
  end

  test "can't update other user's task" do
    new_title = "updated"

    put api_v1_project_task_path(@mproject, @mtask),
      headers: {"Authorization": "HS256 #{@jtoken}"},
      params: {data: {title: new_title}}

    assert_response :forbidden

    put api_v1_project_task_path(@jproject, @mtask),
      headers: {"Authorization": "HS256 #{@jtoken}"},
      params: {data: {title: new_title}}

    assert_response :unauthorized

    assert_equal t("project.errors.not_permitted"), response.body
    refute_equal new_title, @mtask.reload.title
  end

  test "can't delete other user's task" do
    assert_no_difference("Task.count") do
      delete api_v1_project_task_path(@mproject, @mtask),
             headers: {"Authorization": "HS256 #{@jtoken}"}
    end

    assert_response :forbidden

    assert_no_difference("Task.count") do
      delete api_v1_project_task_path(@jproject, @mtask),
             headers: {"Authorization": "HS256 #{@jtoken}"}
    end

    assert_response :unauthorized
    assert_equal t("project.errors.not_permitted"), response.body
  end

  test "can't toggle other user's task status" do
    post toggle_api_v1_project_task_path(@mproject, @mtask),
         headers: {"Authorization": "HS256 #{@jtoken}"}

    assert_response :forbidden

    post toggle_api_v1_project_task_path(@jproject, @mtask),
         headers: {"Authorization": "HS256 #{@jtoken}"}

    assert_response :unauthorized
    refute @mtask.reload.completed
  end
end
