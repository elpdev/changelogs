require "rails_helper"

RSpec.describe "API::V1::Articles", type: :request do
  let(:user) { create(:user) }
  let(:api_key) { create(:api_key, user: user) }
  let(:token) { JWTService.encode({user_id: user.id, api_key_id: api_key.id}) }
  let(:headers) { {"Authorization" => "Bearer #{token}", "Accept" => "application/json"} }
  let(:project) { create(:project) }

  describe "GET /api/v1/articles" do
    it "returns all articles" do
      create_list(:article, 3, project: project)
      get "/api/v1/articles", headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(3)
      expect(json.first).to have_key("project")
    end

    it "filters by project_id" do
      create(:article, project: project)
      other_project = create(:project)
      create(:article, project: other_project)
      get "/api/v1/articles", params: {project_id: project.id}, headers: headers
      expect(JSON.parse(response.body).size).to eq(1)
    end

    it "returns unauthorized without token" do
      get "/api/v1/articles", headers: {"Accept" => "application/json"}
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/v1/articles/:id" do
    let(:article) { create(:article, project: project) }

    it "returns the article by slug" do
      get "/api/v1/articles/#{article.slug}", headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["title"]).to eq(article.title)
      expect(json["reading_time"]).to be_a(Integer)
      expect(json["published"]).to eq(false)
      expect(json["project"]["name"]).to eq(project.name)
    end

    it "returns not found for invalid slug" do
      get "/api/v1/articles/nonexistent", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/articles" do
    let(:valid_params) do
      {article: {
        project_id: project.id,
        title: "What's New in Rails 8",
        content: "## Changes\n\nLots of good stuff."
      }}
    end

    it "creates a draft article" do
      expect {
        post "/api/v1/articles", params: valid_params, headers: headers
      }.to change(Article, :count).by(1)
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["published"]).to eq(false)
    end

    it "creates a published article" do
      params = {article: valid_params[:article].merge(published_at: Time.current.iso8601)}
      post "/api/v1/articles", params: params, headers: headers
      json = JSON.parse(response.body)
      expect(json["published"]).to eq(true)
      expect(json["published_at"]).to be_present
    end

    it "returns errors for invalid params" do
      post "/api/v1/articles", params: {article: {title: ""}}, headers: headers
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    let(:article) { create(:article, project: project) }

    it "publishes a draft article" do
      patch "/api/v1/articles/#{article.slug}",
        params: {article: {published_at: Time.current.iso8601}}, headers: headers
      expect(response).to have_http_status(:ok)
      expect(article.reload).to be_published
    end

    it "updates article content" do
      patch "/api/v1/articles/#{article.slug}",
        params: {article: {title: "Updated Title"}}, headers: headers
      expect(response).to have_http_status(:ok)
      expect(article.reload.title).to eq("Updated Title")
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    let!(:article) { create(:article, project: project) }

    it "destroys the article" do
      expect {
        delete "/api/v1/articles/#{article.slug}", headers: headers
      }.to change(Article, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
