require 'rails_helper'

RSpec.describe "Admin::Words", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/admin/words/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/admin/words/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/admin/words/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/admin/words/new"
      expect(response).to have_http_status(:success)
    end
  end

end
