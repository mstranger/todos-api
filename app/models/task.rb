class Task < ApplicationRecord
  validates :title, presence: true, uniqueness: true, length: { minimum: 3 }
end
