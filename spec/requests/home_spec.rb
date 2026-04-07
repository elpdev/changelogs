require "rails_helper"

RSpec.describe "Homes", type: :request do
  describe "GET /home" do
    it "returns http success for authenticated users" do
      user = create(:user)
      post session_path, params: {email_address: user.email_address, password: "MyString"}

      get home_path
      expect(response).to have_http_status(:success)
    end
  end
end
