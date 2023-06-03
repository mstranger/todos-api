# == Schema Information
#
# Table name: projects
#
#  id         :bigint           not null, primary key
#  name       :string           not null
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

  test "invalid with same name in uppercase" do
    error_message = I18n.t("project.errors.name_exists")
    new_project = Project.new(name: @project.name.upcase, user: @project.user)
    assert_not new_project.valid?
    assert_equal new_project.errors.messages.fetch(:name).first, error_message
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

  test "trim whitespaces" do
    name = "new name    "
    new_project = Project.create(name: name, user: @project.user)
    assert_equal name.strip, new_project.name
  end
end
