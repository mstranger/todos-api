require "test_helper"

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:john) }

  test "login success" do
    token = authenticate! @user
    data = decode(token)

    assert_equal 200, response.status
    assert_equal @user.id, data["user_id"]
  end

  test "login fail" do
    @user.email = "other@mail.com"
    authenticate! @user

    assert_equal 401, response.status
    assert_equal t("user.errors.auth_fail"), parse_resp["error"]
  end
end
