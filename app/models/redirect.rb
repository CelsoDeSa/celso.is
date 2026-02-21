class Redirect < ApplicationRecord
  validates :source, presence: true, uniqueness: true
  validates :destination, presence: true

  scope :active, -> { where(active: true) }
end
