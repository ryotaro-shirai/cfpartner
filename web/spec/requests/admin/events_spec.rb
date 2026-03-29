require 'rails_helper'

RSpec.describe "Admin::Events", type: :request do
  include Admin::BasicAuthRequestHelper
  let!(:auth_headers) { basic_auth_headers }

  describe "GET /admin/events/new" do
    context "when authenticated with valid basic auth" do
      it 'returns 200' do
        get new_admin_event_path, headers: auth_headers
        expect(response).to have_http_status(:ok)
      end
    end

    context "when no basic auth header is provided" do
      it "returns 401" do
        get new_admin_event_path
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /admin/events" do
    let!(:name) { "test_event" }
    let!(:site_url) { "https://example.com" }
    let!(:start_at) { Time.current.ago(1.day) }
    let!(:end_at) { Time.current.since(1.day) }

    context "when params is valid" do
      it 'creates an event and redirects' do
        expect {
          post admin_events_path, params: {
            event: {
              name: name,
              site_url: site_url,
              start_at: start_at,
              end_at: end_at
            }
          }, headers: auth_headers
        }.to change { Event.count }.by(1)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_admin_event_path)
        expect(flash[:notice]).to include("イベントを作成しました")
      end
    end

    context "when params is invalid" do
      it 'does not create an event and returns 422' do
        expect {
          post admin_events_path, params: {
            event: {
              name: "",
              site_url: site_url,
              start_at: start_at,
              end_at: end_at
            }
          }, headers: auth_headers
        }.not_to change { Event.count }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when no basic auth header is provided" do
      it "does not create an event and returns 401" do
        expect {
          post admin_events_path, params: {
            event: {
              name: name,
              site_url: site_url,
              start_at: start_at,
              end_at: end_at
            }
          }
        }.not_to change { Event.count }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
