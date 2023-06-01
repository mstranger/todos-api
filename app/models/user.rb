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

  # TODO: password test validation
  # TODO: email case sensitive validation

  validates :email,
            presence: true,
            format: {with: URI::MailTo::EMAIL_REGEXP},
            uniqueness: {message: I18n.t("user.errors.login_exists")},
            length: {minimum: 3, maximum: 50}
  validates :password,
            format: {with: /\A[a-zA-Z0-9]{6,}\z/, message: I18n.t("user.errors.password_format")}

  has_many :projects, dependent: :destroy
  has_many :comments, dependent: :destroy

  # TODO: remove this
  def project_tasks(project_id)
    projects.find { |t| t.id == project_id }.tasks
  end
end
