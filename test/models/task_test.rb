# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  deadline   :datetime
#  priority   :string
#  completed  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class TaskTest < ActiveSupport::TestCase
  setup do
    @task = Task.new(title: "example")
  end

  test "valid task" do
    assert @task.valid?
  end

  test "invalid without title" do
    @task.title = ""
    refute @task.valid?
    refute_nil @task.errors.messages.fetch(:title, nil)
  end

  test "invalid with length less then 3" do
    @task.title = "ab"
    refute @task.valid?, "too short"

    @task.title = "abc"
    assert @task.valid?
  end

  test "invalid with existing title" do
    @task.title = tasks(:one).title
    refute @task.valid?
  end
end
