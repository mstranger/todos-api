# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  task_id    :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"
require "minitest/autorun"

class CommentTest < ActiveSupport::TestCase
  setup do
    @comment = comments(:one)
  end

  test "valid comment" do
    assert @comment.valid?
  end

  test "invalid without content and attachment" do
    @comment.content = ""
    assert_not @comment.valid?
    assert_equal I18n.t("comment.errors.empty_record"), @comment.errors.messages[:content].first
  end

  test "valid with attachment and without content" do
    file = Rails.root.join(fixture_path, "files/example.jpg").open
    @comment.content = ""
    @comment.image.attach(io: file, filename: "attachment")
    assert @comment.valid?
  end

  test "can attach JPG and PNG files" do
    file = Rails.root.join(fixture_path, "files/example.jpg").open
    @comment.image.attach(io: file, filename: "attachment")
    assert @comment.image.attached?

    Comment::MIME_TYPES.each do |mime_type|
      @comment.image.stub :content_type, mime_type do
        assert @comment.valid?, "invalid for '#{mime_type}'"
      end
    end
  end

  test "fail to attach a TXT file" do
    file = Rails.root.join(fixture_path, "files/example.jpg").open
    @comment.image.attach(io: file, filename: "attachment")
    @comment.image.stub :content_type, "text/plain" do
      assert_not @comment.valid?
      assert_equal @comment.errors.messages[:image].first, I18n.t("comment.errors.image_invalid")
    end
  end

  test "fail to attach too big file" do
    file = Rails.root.join(fixture_path, "files/example.jpg").open

    file.stub :size, Comment::FILE_MAX_SIZE do
      @comment.image.attach(io: file, filename: "attachment")
      assert @comment.valid?
    end

    file.stub :size, Comment::FILE_MAX_SIZE + 1 do
      @comment.image.attach(io: file, filename: "attachment")
      assert_not @comment.valid?
    end
  end

  test "fail for too long content" do
    message = I18n.t("comment.errors.content_large", size: Comment::CONTENT_MAX_SIZE)
    @comment.content = "a" * (Comment::CONTENT_MAX_SIZE + 1)
    assert_not @comment.valid?
    assert_equal message, @comment.errors.messages[:content].first
  end

  test "relationships" do
    assert_respond_to @comment, :task, "belongs to task"
    assert_respond_to @comment, :user, "belongs to user"
  end
end
