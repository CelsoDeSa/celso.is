class Page < ApplicationRecord
  extend FriendlyId

  has_rich_text :content

  friendly_id :title, use: :slugged

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(position: :asc) }

  def should_generate_new_friendly_id?
    title_changed? || super
  end
end
