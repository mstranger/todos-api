# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  deadline   :datetime
#  priority   :integer          default(0), not null
#  completed  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :integer          not null
#
class Task < ApplicationRecord
  validates :title, presence: true, uniqueness: { scope: :project }, length: { minimum: 3 }
  validates :priority, presence: true

  belongs_to :project
  has_many :comments, dependent: :destroy
end
