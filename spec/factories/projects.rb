FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    description { "An open source project" }
    sequence(:github_url) { |n| "https://github.com/org/project-#{n}" }
    language { "Ruby" }
    stars_count { 1000 }
  end
end
