# == Schema Information
#
# Table name: tasks
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  deadline   :datetime
#  completed  :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :integer          not null
#  order      :integer          not null
#
class Task < ApplicationRecord
  # TODO: test 'order' column

  validates :title, presence: true,
                    uniqueness: {scope: :project, case_sensitive: false},
                    length: {minimum: 3}

  belongs_to :project
  has_many :comments, dependent: :destroy
end
