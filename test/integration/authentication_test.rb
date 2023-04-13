require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "login success" do
    post auth_login_path, params: { email: "jdoe@mail.com", password: "password" }

    assert_equal response.status, 200

    token = JSON.parse(response.body).dig("token")
    data = JWT.decode(token, Rails.application.secret_key_base).first

    assert_equal User.last.id, data["user_id"]
  end

  test "login fail" do
    post auth_login_path, params: { email: "some@mail.com", password: "password" }

    assert_equal 401, response.status
    assert_equal "Invalid email or password", JSON.parse(response.body).dig("error")
  end
end
