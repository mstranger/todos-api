class Task < ApplicationRecord
  validates :title, presence: true, uniqueness: true
end
