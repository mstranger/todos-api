# == Schema Information
#
# Table name: tasks
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  deadline   :datetime
#  priority   :integer          default(0), not null
#  completed  :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :integer          not null
#
class Task < ApplicationRecord
  validates :title, presence: true,
                    uniqueness: {scope: :project, case_sensitive: false},
                    length: {minimum: 3}

  validates :priority, presence: true

  belongs_to :project
  has_many :comments, dependent: :destroy
end
