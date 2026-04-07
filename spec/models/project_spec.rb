require "rails_helper"

RSpec.describe Project, type: :model do
  describe "associations" do
    it { should have_many(:articles).dependent(:destroy) }
  end

  describe "validations" do
    subject { create(:project) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:slug) }
    it { should validate_presence_of(:github_url) }
    it { should validate_uniqueness_of(:github_url) }

    it "rejects invalid github_url" do
      project = build(:project, github_url: "https://example.com/repo")
      expect(project).not_to be_valid
      expect(project.errors[:github_url]).to include("must be a valid GitHub repository URL")
    end

    it "accepts valid github_url" do
      project = build(:project, github_url: "https://github.com/rails/rails")
      expect(project).to be_valid
    end
  end

  describe "#generate_slug" do
    it "auto-generates slug from name" do
      project = build(:project, name: "Rails Framework", slug: nil)
      project.valid?
      expect(project.slug).to eq("rails-framework")
    end

    it "does not override provided slug" do
      project = build(:project, name: "Rails", slug: "custom-slug")
      project.valid?
      expect(project.slug).to eq("custom-slug")
    end
  end

  describe "#to_param" do
    it "returns the slug" do
      project = build(:project, slug: "rails-rails")
      expect(project.to_param).to eq("rails-rails")
    end
  end

  describe "#github_owner_repo" do
    it "extracts owner/repo from github_url" do
      project = build(:project, github_url: "https://github.com/rails/rails")
      expect(project.github_owner_repo).to eq("rails/rails")
    end
  end

  describe "scopes" do
    describe ".by_popularity" do
      it "orders by stars_count descending" do
        low = create(:project, stars_count: 100)
        high = create(:project, stars_count: 10000)
        expect(described_class.by_popularity).to eq([high, low])
      end
    end

    describe ".with_articles" do
      it "returns only projects with articles" do
        with = create(:project, articles_count: 3)
        create(:project, articles_count: 0)
        expect(described_class.with_articles).to eq([with])
      end
    end
  end
end
