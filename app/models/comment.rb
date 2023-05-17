# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  task_id    :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :user

  has_one_attached :image

  validate :content_or_attachment
  validate :acceptable_image

  # TODO: I18n

  def acceptable_image
    return unless image.attached?

    types = ["image/jpeg", "image/png"]
    max_size = 2.megabyte

    if image.blob.byte_size > max_size
      errors.add(:image, "is too big (should be less than #{max_size / (1024 * 1024)}Mb)")
    end

    errors.add(:image, "must be a JPEG or PNG file") unless types.include?(image.content_type)
  end

  # TODO: write tests
  def content_or_attachment
    errors.add(:content, message: "should be less than 256 chars") if !content.empty? && (content.length > 256)

    return if !content.empty? || image.attached?

    errors.add(:content, message: "or attachment must be present")
  end
end
