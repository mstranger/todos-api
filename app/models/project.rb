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
class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  # TODO: test case sensitive
  validates :name, 
    presence: {message: I18n.t("project.errors.name_blank")},
    uniqueness: {scope: :user, case_sensitive: false, message: I18n.t("project.errors.name_exists")}

  # TODO: test this
  before_validation(on: :create) { name.strip! }

  scope :with_tasks, -> { includes([:tasks]) }
end
