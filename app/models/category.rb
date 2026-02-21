class Category < ApplicationRecord
  extend FriendlyId

  has_many :posts, dependent: :destroy

  friendly_id :name, use: :slugged

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  scope :ordered, -> { order(position: :asc) }

  def should_generate_new_friendly_id?
    name_changed? || super
  end
end
