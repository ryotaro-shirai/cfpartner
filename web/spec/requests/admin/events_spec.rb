require 'rails_helper'

RSpec.describe "Admin::Events", type: :request do
  include Admin::BasicAuthRequestHelper
  let!(:auth_headers) { headers }

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
    let!(:event_name) { "test_event" }
    let!(:event_site_url) { "https://example.com" }
    let!(:event_start_at) { Time.current.ago(1.day) }
    let!(:event_end_at) { Time.current.since(1.day) }

    context "when params is valid" do
      it 'creates an event and redirects' do
        expect {
          post admin_events_path, params: { 
            event: {
              name: event_name,
              site_url: event_site_url,
              start_at: event_start_at,
              end_at: event_end_at
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
              site_url: event_site_url,
              start_at: event_start_at,
              end_at: event_end_at
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
              name: event_name,
              site_url: event_site_url,
              start_at: event_start_at,
              end_at: event_end_at
            }
          }
        }.not_to change { Event.count }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
