# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  task_id    :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Comment < ApplicationRecord
  validates :content, presence: true

  belongs_to :task
  belongs_to :user

  has_one_attached :image

  validate :acceptable_image

  def acceptable_image
    return unless image.attached?

    types = ["image/jpeg", "image/png"]
    max_size = 10.megabyte

    errors.add(:image, "is too big") unless image.blob.byte_size <= max_size
    errors.add(:image, "must be a JPEG or PNG") unless types.include?(image.content_type)
  end
end
