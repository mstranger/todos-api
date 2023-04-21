module CustomHelper
  def authenticate!(user, password = "password")
    post auth_login_path,
         params: {
           email: user.email,
           password: password
         }

    parse_resp["token"]
  end

  def parse_resp
    JSON.parse(response.body).with_indifferent_access
  end

  def decode(token)
    JWT.decode(token, Rails.application.secret_key_base).first
  end

  def t(msg, **args)
    I18n.translate(msg, **args)
  end
end
