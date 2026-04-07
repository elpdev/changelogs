require "rails_helper"

RSpec.describe Article, type: :model do
  describe "associations" do
    it { should belong_to(:project) }
  end

  describe "validations" do
    subject { create(:article) }

    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:slug) }
    it { should validate_presence_of(:content) }
  end

  describe "#generate_slug" do
    it "auto-generates slug from title" do
      article = build(:article, title: "What's New in Rails 8", slug: nil)
      article.valid?
      expect(article.slug).to eq("what-s-new-in-rails-8")
    end

    it "does not override provided slug" do
      article = build(:article, title: "Rails 8", slug: "custom-slug")
      article.valid?
      expect(article.slug).to eq("custom-slug")
    end
  end

  describe "#to_param" do
    it "returns the slug" do
      article = build(:article, slug: "whats-new")
      expect(article.to_param).to eq("whats-new")
    end
  end

  describe "#published?" do
    it "returns true when published_at is in the past" do
      article = build(:article, :published)
      expect(article).to be_published
    end

    it "returns false when published_at is nil" do
      article = build(:article, published_at: nil)
      expect(article).not_to be_published
    end

    it "returns false when published_at is in the future" do
      article = build(:article, :scheduled)
      expect(article).not_to be_published
    end
  end

  describe "#reading_time" do
    it "returns at least 1 minute" do
      article = build(:article, content: "Short")
      expect(article.reading_time).to eq(1)
    end

    it "calculates based on word count" do
      article = build(:article, content: "word " * 600)
      expect(article.reading_time).to eq(3)
    end
  end

  describe "scopes" do
    describe ".published" do
      it "returns articles with published_at in the past" do
        published = create(:article, :published)
        create(:article) # draft
        create(:article, :scheduled)
        expect(described_class.published).to eq([published])
      end
    end

    describe ".draft" do
      it "returns articles without published_at" do
        create(:article, :published)
        draft = create(:article)
        expect(described_class.draft).to eq([draft])
      end
    end

    describe ".recent" do
      it "returns published articles ordered by published_at desc" do
        older = create(:article, published_at: 2.days.ago)
        newer = create(:article, published_at: 1.day.ago)
        expect(described_class.recent).to eq([newer, older])
      end
    end
  end
end
