require "rails_helper"

RSpec.describe "API::V1::Projects", type: :request do
  let(:user) { create(:user) }
  let(:api_key) { create(:api_key, user: user) }
  let(:token) { JWTService.encode({user_id: user.id, api_key_id: api_key.id}) }
  let(:headers) { {"Authorization" => "Bearer #{token}", "Accept" => "application/json"} }

  describe "GET /api/v1/projects" do
    it "returns all projects" do
      create_list(:project, 3)
      get "/api/v1/projects", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end

    it "returns unauthorized without token" do
      get "/api/v1/projects", headers: {"Accept" => "application/json"}
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/v1/projects/:id" do
    let(:project) { create(:project) }

    it "returns the project by slug" do
      get "/api/v1/projects/#{project.slug}", headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq(project.name)
      expect(json["slug"]).to eq(project.slug)
    end

    it "returns not found for invalid slug" do
      get "/api/v1/projects/nonexistent", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/projects" do
    let(:valid_params) do
      {project: {name: "Rails", github_url: "https://github.com/rails/rails", language: "Ruby"}}
    end

    it "creates a project" do
      expect {
        post "/api/v1/projects", params: valid_params, headers: headers
      }.to change(Project, :count).by(1)
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq("Rails")
      expect(json["slug"]).to eq("rails")
    end

    it "returns errors for invalid params" do
      post "/api/v1/projects", params: {project: {name: ""}}, headers: headers
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PATCH /api/v1/projects/:id" do
    let(:project) { create(:project) }

    it "updates the project" do
      patch "/api/v1/projects/#{project.slug}",
        params: {project: {stars_count: 5000}}, headers: headers
      expect(response).to have_http_status(:ok)
      expect(project.reload.stars_count).to eq(5000)
    end
  end

  describe "DELETE /api/v1/projects/:id" do
    let!(:project) { create(:project) }

    it "destroys the project" do
      expect {
        delete "/api/v1/projects/#{project.slug}", headers: headers
      }.to change(Project, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
