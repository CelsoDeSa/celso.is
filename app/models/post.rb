class Post < ApplicationRecord
  extend FriendlyId

  belongs_to :category
  has_rich_text :content

  friendly_id :title, use: :slugged

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :published, -> { where(published: true).where("published_at <= ?", Time.current) }
  scope :draft, -> { where(published: false).or(where("published_at > ?", Time.current)) }
  scope :ordered, -> { order(position: :asc, published_at: :desc) }

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def published?
    published && published_at <= Time.current
  end
end
