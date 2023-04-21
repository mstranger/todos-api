# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  deadline   :datetime
#  priority   :integer          default(0), not null
#  completed  :boolean          default(FALSE)
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

  test "associations" do
    assert_respond_to @task, :project, "belongs to project"
  end

  test "invalid without title" do
    @task.title = ""
    refute @task.valid?
    refute_nil @task.errors.messages.fetch(:title, nil)
  end

  test "invalid with title length less then 3" do
    @task.title = "ab"
    refute @task.valid?, "too short"

    @task.title = "abc"
    assert @task.valid?
  end

  test "invalid without priority" do
    @task.priority = nil
    refute @task.valid?
    refute_nil @task.errors.messages.fetch(:priority, nil)
  end

  test "invalid with same title within same project" do
    new_task = Task.new(title: @task.title, project: @task.project)
    refute new_task.valid?
    refute_nil new_task.errors.messages.fetch(:title, nil)
  end

  test "valid with same title and different projects" do
    new_task = Task.new(title: @task.title, project: projects(:two))
    assert new_task.valid?
  end
end
