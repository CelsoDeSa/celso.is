class Page < ApplicationRecord
  extend FriendlyId

  has_many :posts, dependent: :destroy
  has_rich_text :content

  friendly_id :title, use: :slugged

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :published, -> { where(published: true) }
  scope :categories, -> { where(acts_as_category: true) }
  scope :static_pages, -> { where(acts_as_category: false) }
  scope :ordered, -> { order(position: :asc) }

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def category?
    acts_as_category?
  end

  def static_page?
    !acts_as_category?
  end
end
