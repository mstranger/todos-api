# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  deadline   :datetime
#  priority   :string
#  completed  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
class Task < ApplicationRecord
  validates :title, presence: true, uniqueness: true, length: { minimum: 3 }
  validates :priority, presence: true

  belongs_to :user
end
