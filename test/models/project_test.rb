# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  setup do
    @project = projects(:one)
  end

  test "valid project" do
    assert @project.valid?
  end

  test "invalid without name" do
    @project.name = ""
    assert_not @project.valid?
    assert_not_nil @project.errors.messages.fetch(:name, nil)
  end

  test "associations" do
    assert_respond_to @project, :user, "belongs to user"
    assert_respond_to @project, :tasks, "has many tasks"
  end

  test "valid with same name for different users" do
    new_project = Project.new(name: @project.name, user: users(:mike))

    assert new_project.valid?
  end

  test "invalid with same name within same user" do
    new_project = Project.new(name: @project.name, user: @project.user)

    assert_not new_project.valid?
    assert_not_nil new_project.errors.messages.fetch(:name, nil)
  end
end
