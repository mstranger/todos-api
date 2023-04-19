require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
  end

  test "create user success" do
    assert_difference("User.count") do
      post users_path, params: { email: "new@mail.com", password: "password" }
    end

    assert_equal 201, response.status
  end

  test "create user fail" do
    assert_no_difference("User.count") do
      post users_path, params: { email: @user.email, password: "password" }
    end

    assert_equal 422, response.status
  end

  test "update user success" do
    new_email = "udpated@mail.com"
    token = authenticate! @user

    patch users_path,
      headers: { "Authorization": "HS256 #{token}" },
      params: { email: new_email, password: "password" }

    assert_equal 200, response.status
    assert_equal new_email, @user.reload.email
  end

  test "update user fail" do
    new_email = "udpated@mail.com"
    patch users_path, params: { email: new_email, password: "password" }

    assert_equal 401, response.status
    assert_equal t("user.errors.login_first"), parse_resp["error"]
  end

  test "get self info success" do
    token = authenticate! @user

    get me_path, headers: { "Authorization": "HS256 #{token}" }

    assert_equal 200, response.status
    assert_equal @user.email, parse_resp["email"]
  end

  test "get self info fail" do
    get me_path

    assert_equal 401, response.status
    assert_equal t("user.errors.login_first"), parse_resp["error"]
  end
end
