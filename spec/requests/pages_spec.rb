require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /privacy" do
    it "HTTPステータス 200" do
      get "/privacy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /terms" do
    it "HTTPステータス 200" do
      get "/terms"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /about" do
    it "HTTPステータス 200" do
      get "/about"
      expect(response).to have_http_status(:success)
    end
  end

end
