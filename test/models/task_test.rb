# == Schema Information
#
# Table name: tasks
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  deadline   :datetime
#  priority   :integer          default(0), not null
#  completed  :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :integer          not null
#
require "test_helper"

class TaskTest < ActiveSupport::TestCase
  setup do
    @task = tasks(:one)
  end

  test "valid task" do
    assert @task.valid?
  end

  test "relationships" do
    assert_respond_to @task, :project, "belongs to project"
    assert_respond_to @task, :comments, "has many projects"
  end

  test "invalid without title" do
    @task.title = ""
    assert_not @task.valid?
    assert_not_nil @task.errors.messages.fetch(:title, nil)
  end

  test "invalid with title length less then 3" do
    @task.title = "ab"
    assert_not @task.valid?, "too short"

    @task.title = "abc"
    assert @task.valid?
  end

  test "invalid without priority" do
    @task.priority = nil
    assert_not @task.valid?
    assert_not_nil @task.errors.messages.fetch(:priority, nil)
  end

  test "invalid with same title within same project" do
    new_task = Task.new(title: @task.title, project: @task.project)
    assert_not new_task.valid?
    assert_not_nil new_task.errors.messages.fetch(:title, nil)
  end

  test "valid with same title and different projects" do
    new_task = Task.new(title: @task.title, project: projects(:two))
    assert new_task.valid?
  end
end
