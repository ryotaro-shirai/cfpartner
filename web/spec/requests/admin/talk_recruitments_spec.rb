require 'rails_helper'

RSpec.describe "Admin::TalkRecruitments", type: :request do
  include Admin::BasicAuthRequestHelper
  let!(:auth_headers) { basic_auth_headers }

  describe "GET /admin/talk_recruitments/new" do
    context "when authenticated with valid basic auth" do
      it 'returns 200' do
        get new_admin_talk_recruitment_path, headers: auth_headers
        expect(response).to have_http_status(:ok)
      end
    end

    context "when no basic auth header is provided" do
      it "returns 401" do
        get new_admin_talk_recruitment_path
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /admin/talk_recruitments" do
    let!(:title) { "test_talk_recruitment" }
    let!(:site_url) { "https://example.com" }
    let!(:start_at) { Time.current.ago(1.day) }
    let!(:end_at) { Time.current.since(1.day) }
    let!(:talk_type) { :short_session }
    let!(:event) { create(:event) }

    context "when params is valid" do
      it 'creates a talk_recruitment and redirects' do
        expect {
          post admin_talk_recruitments_path, params: {
            talk_recruitment: {
              title: title,
              site_url: site_url,
              start_at: start_at,
              end_at: end_at,
              talk_type: talk_type,
              event_id: event.id
            }
          }, headers: auth_headers
        }.to change { TalkRecruitment.count }.by(1)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_admin_talk_recruitment_path)
        expect(flash[:notice]).to include("CfPを作成しました")
      end
    end

    context "when params is invalid" do
      it 'does not create a talk_recruitment and returns 422' do
        expect {
          post admin_talk_recruitments_path, params: {
            talk_recruitment: {
              title: "",
              site_url: site_url,
              start_at: start_at,
              end_at: end_at,
              talk_type: talk_type,
              event_id: event.id
            }
          }, headers: auth_headers
        }.not_to change { TalkRecruitment.count }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when no basic auth header is provided" do
      it "does not create a talk_recruitment and returns 401" do
        expect {
          post admin_talk_recruitments_path, params: {
            talk_recruitment: {
              title: title,
              site_url: site_url,
              start_at: start_at,
              end_at: end_at,
              talk_type: talk_type,
              event_id: event.id
            }
          }
        }.not_to change { TalkRecruitment.count }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
