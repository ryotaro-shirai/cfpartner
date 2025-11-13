require 'rails_helper'

RSpec.describe "Events", type: :request do
  describe "GET /" do
    let!(:event) { create :event }
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
      expect(response.body).to include event.name
    end
  end
end
