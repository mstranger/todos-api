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
  MIME_TYPES = ["image/jpeg", "image/png"].freeze
  FILE_MAX_SIZE = 2.megabytes
  CONTENT_MAX_SIZE = 256

  belongs_to :task
  belongs_to :user

  has_one_attached :image

  validates :content, length: {
    maximum: 256, message: I18n.t("comment.errors.content_large", size: CONTENT_MAX_SIZE)
  }

  validate :content_or_attachment
  validate :acceptable_image

  def acceptable_image
    return unless image.attached?

    if image.blob.byte_size > FILE_MAX_SIZE
      errors.add(:image, I18n.t("comment.errors.image_large", size: FILE_MAX_SIZE / (1024 * 1024)))
    end

    errors.add(:image, I18n.t("comment.errors.image_invalid")) unless MIME_TYPES.include?(image.content_type)
  end

  def content_or_attachment
    return if !content.empty? || image.attached?

    errors.add(:content, message: I18n.t("comment.errors.empty_record"))
  end
end
