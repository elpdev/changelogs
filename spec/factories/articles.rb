FactoryBot.define do
  factory :article do
    project
    sequence(:title) { |n| "Article #{n}: What's New" }
    summary { "A summary of the latest changes" }
    content { "## What's New\n\nThis release includes several improvements." }
    published_at { nil }

    trait :published do
      published_at { Time.current }
    end

    trait :scheduled do
      published_at { 1.day.from_now }
    end
  end
end
