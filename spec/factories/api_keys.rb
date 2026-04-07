FactoryBot.define do
  factory :api_key, class: "APIKey" do
    user
    name { "Test API Key" }
    secret_key { "test_secret_key_12345" }
  end
end
