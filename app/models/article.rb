class Article < ApplicationRecord
  belongs_to :project, counter_cache: true

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :content, presence: true

  before_validation :generate_slug, on: :create

  scope :published, -> { where.not(published_at: nil).where(published_at: ..Time.current) }
  scope :draft, -> { where(published_at: nil) }
  scope :recent, -> { published.order(published_at: :desc) }

  def to_param
    slug
  end

  def published?
    published_at.present? && published_at <= Time.current
  end

  def reading_time
    minutes = (content.to_s.split.size / 200.0).ceil
    [minutes, 1].max
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title published_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[project]
  end

  private

  def generate_slug
    self.slug ||= title&.parameterize
  end
end
