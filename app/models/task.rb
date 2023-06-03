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
#  position   :integer          not null
#
class Task < ApplicationRecord
  # TODO: test 'position' behavior

  validates :title, presence: true,
                    uniqueness: {scope: :project, case_sensitive: false},
                    length: {minimum: 3}

  before_validation(on: :create) { title.strip! }

  belongs_to :project
  has_many :comments, dependent: :destroy

  scope :with_comments, -> { includes([:comments]) }
end
