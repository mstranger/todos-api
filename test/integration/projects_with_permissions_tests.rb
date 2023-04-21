require "test_helper"

class ProjectsWithPermitionsTest < ActionDispatch::IntegrationTest
  setup do
    @john = users(:john)
    @mike = users(:mike)
    @jtoken = authenticate! @john
    @mtoken = authenticate! @mike
    @jproject = projects(:one)
    @mproject = projects(:two)
  end

  test "list only author's projects" do
    get api_v1_projects_path, headers: {"Authorization": "HS256 #{@jtoken}"}

    assert_equal 1, parse_resp[:data].count
    assert_equal @jproject.id, parse_resp[:data].first[:data][:id]
  end

  test "show project only to its author" do
    get api_v1_project_path(@jproject), headers: {"Authorization": "HS256 #{@jtoken}"}

    assert_equal @jproject.id, parse_resp[:data][:id]

    get api_v1_project_path(@jproject), headers: {"Authorization": "HS256 #{@mtoken}"}

    assert_response :forbidden
    assert_equal t("project.errors.not_permitted"), response.body
  end

  test "update project only by the author" do
    new_name = "updated"

    patch api_v1_project_path(@jproject),
          headers: {"Authorization": "HS256 #{@mtoken}"},
          params: {data: {name: new_name}}

    assert_response :forbidden
    assert_equal t("project.errors.not_permitted"), response.body
    refute_equal new_name, @jproject.reload.name
  end

  test "delete project only by the author" do
    assert_no_difference("Project.count") do
      delete api_v1_project_path(@jproject), headers: {"Authorization": "HS256 #{@mtoken}"}
    end

    assert_response :forbidden
    assert_equal t("project.errors.not_permitted"), response.body
  end
end
