# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  name            :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.new(email: "foo@bar.com", password: "password")
  end

  test "valid user" do
    assert @user.valid?
  end

  test "invalid without email" do
    @user.email = ""
    refute @user.valid?
    refute_nil @user.errors.messages.fetch(:email, nil)
  end

  test "invalid without password" do
    @user.password = nil
    refute @user.valid?
    refute_nil @user.errors.messages.fetch(:password, nil)
  end

  test "invalid with existing email" do
    @user.email = "jdoe@mail.com"
    refute @user.valid?
  end
end
