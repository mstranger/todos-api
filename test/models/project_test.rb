require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  setup do
    @project = projects(:one)
  end

  test "valid task" do
    assert @project.valid?
  end

  test "invalid without name" do
    @project.name = ""
    refute @project.valid?
    refute_nil @project.errors.messages.fetch(:name, nil)
  end

  test "valid with same name for different users" do
    @project.save
    new_project = Project.new(name: @project.name, user: users(:mike))

    assert new_project.valid?
    assert_difference("Project.count") { new_project.save }
  end

  test "invalid with same name within same user" do
    @project.save
    new_project = Project.new(name: @project.name, user: @project.user)

    refute new_project.valid?
    refute_nil new_project.errors.messages.fetch(:name, nil)
    assert_no_difference("Project.count") { new_project.save }
  end
end
