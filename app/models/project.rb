# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, uniqueness: {scope: :user}
end
