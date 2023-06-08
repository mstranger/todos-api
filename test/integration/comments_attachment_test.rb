require "test_helper"

class CommentsAttachmentTest < ActionDispatch::IntegrationTest
  setup do
    @token = authenticate! users(:john)
    @project = projects(:one)
    @task = tasks(:one)
  end

  test "can attach image" do
    post api_v1_project_task_comments_path(@project, @task),
         headers: {Authorization: "HS256 #{@token}"},
         params: {
           content: "example",
           image: fixture_file_upload("example.jpg", "image/jpeg")
         }

    comment = @task.reload.comments.last
    assert comment.image.attached?
  end
end
