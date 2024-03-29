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
class User < ApplicationRecord
  has_secure_password

  validates :email,
            presence: true,
            format: {with: URI::MailTo::EMAIL_REGEXP},
            uniqueness: {case_sensitive: false, message: I18n.t("user.errors.login_exists")},
            length: {minimum: 3, maximum: 50}
  validates :password,
            format: {with: /\A[a-zA-Z0-9]{6,}\z/, message: I18n.t("user.errors.password_format")}

  has_many :projects, dependent: :destroy
  has_many :comments, dependent: :destroy
end
