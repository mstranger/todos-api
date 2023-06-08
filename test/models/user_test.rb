# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  name            :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.new(email: "foo@bar.com", password: "PASSword123")
  end

  test "valid user" do
    assert @user.valid?
  end

  test "invalid without email" do
    @user.email = ""
    assert_not @user.valid?
    assert_not_nil @user.errors.messages.fetch(:email, nil)
  end

  test "invalid without password" do
    @user.password = nil
    assert_not @user.valid?
    assert_not_nil @user.errors.messages.fetch(:password, nil)
  end

  test "invalid with short password" do
    @user.password = "12345"
    assert_not @user.valid?

    @user.password = "123456"
    assert @user.valid?
  end

  test "invalid when password has inproper symbols" do
    @user.password = "123$abc#"
    assert_not @user.valid?
  end

  test "invalid with invalid email" do
    bad_emails = %w[some.mail.com @mail.com joe:)@mail.com]
    bad_emails.each do |mail|
      @user.email = mail
      assert_not @user.valid?, "must be invalid for #{mail}"
    end
  end

  test "invalid with existing email" do
    @user.email = users(:john).email
    assert_not @user.valid?
  end

  test "email case insensitive" do
    @user.save
    new_user = User.new(email: @user.email.upcase, password: "password")
    assert_not new_user.valid?
  end

  test "relationships" do
    assert_respond_to @user, :projects, "has many projects"
    assert_respond_to @user, :comments, "has many comments"
  end
end
