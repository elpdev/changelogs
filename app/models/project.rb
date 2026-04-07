class Project < ApplicationRecord
  has_many :articles, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :github_url, presence: true, uniqueness: true,
    format: {with: %r{\Ahttps://github\.com/.+/.+\z}, message: "must be a valid GitHub repository URL"}

  before_validation :generate_slug, on: :create

  scope :by_popularity, -> { order(stars_count: :desc) }
  scope :with_articles, -> { where("articles_count > 0") }

  def to_param
    slug
  end

  def github_owner_repo
    github_url&.sub("https://github.com/", "")
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name language]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[articles]
  end

  private

  def generate_slug
    self.slug ||= name&.parameterize
  end
end
