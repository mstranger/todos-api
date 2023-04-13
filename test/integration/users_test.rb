require "test_helper"

class UsersTest < ActionDispatch::IntegrationTest
  test "create user success" do
    users_count = User.count

    post users_path, params: { email: "some@mail.com", password: "password" }

    assert_equal 201, response.status
    assert_equal users_count + 1, User.count
  end

  test "create user fail" do
    users_count = User.count

    post users_path, params: { email: "jdoe@mail.com", password: "password" }

    errors = JSON.parse(response.body).dig("errors")

    assert_equal 422, response.status
    assert_includes errors, "Email has already been taken"
    assert_equal users_count, User.count
  end

  test "update user success" do
    post auth_login_path, params: { email: "jdoe@mail.com", password: "password" }
    token = JSON.parse(response.body).dig("token")

    patch users_path,
      headers: { "Authorization": "HS256 #{token}" },
      params: { email: "jd@mail.com", password: "password" }

    assert_equal 200, response.status
    assert_equal "jd@mail.com", User.last.email
  end

  test "update user fail" do
    patch users_path, params: { email: "jd@mail.com", password: "password" }

    assert_equal 401, response.status
    assert_equal "Please, sign in first", JSON.parse(response.body).dig("error")
  end

  test "GET me success" do
    post auth_login_path, params: { email: "jdoe@mail.com", password: "password" }
    token = JSON.parse(response.body).dig("token")

    get me_path, headers: { "Authorization": "HS256 #{token}" }

    assert_equal 200, response.status
    assert_equal "jdoe@mail.com", JSON.parse(response.body).dig("email")
  end

  test "GET me fail" do
    get me_path

    assert_equal 401, response.status
    assert_equal "Please, sign in first", JSON.parse(response.body).dig("error")
  end
end
