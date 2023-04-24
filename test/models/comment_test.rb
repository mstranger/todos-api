# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  task_id    :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class CommentTest < ActiveSupport::TestCase
  setup do
    @comment = comments(:one)
  end

  test "valid comment" do
    assert @comment.valid?
  end

  test "invalid without content" do
    @comment.content = ""
    refute @comment.valid?
    refute_nil @comment.errors.messages.fetch(:content, nil)
  end

  test "relationships" do
    assert_respond_to @comment, :task, "belongs to task"
    assert_respond_to @comment, :user, "belongs to user"
  end
end
