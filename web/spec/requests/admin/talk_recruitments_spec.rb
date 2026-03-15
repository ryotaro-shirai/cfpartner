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
    let!(:talk_recruitment_title) { "test_talk_recruitment" }
    let!(:talk_recruitment_site_url) { "https://example.com" }
    let!(:talk_recruitment_start_at) { Time.current.ago(1.day) }
    let!(:talk_recruitment_end_at) { Time.current.since(1.day) }
    let!(:talk_recruitment_status) { :published_information }
    let!(:talk_recruitment_event) { create(:event) }

    context "when params is valid" do
      it 'creates an talk_recruitment and redirects' do
        expect {
          post admin_talk_recruitments_path, params: { 
            talk_recruitment: {
              title: talk_recruitment_title,
              site_url: talk_recruitment_site_url,
              start_at: talk_recruitment_start_at,
              end_at: talk_recruitment_end_at,
              status: talk_recruitment_status,
              event_id: talk_recruitment_event.id
            }
          }, headers: auth_headers
        }.to change { TalkRecruitment.count }.by(1)  
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_admin_talk_recruitment_path)
        expect(flash[:notice]).to include("CfPを作成しました")
      end
    end

    context "when params is invalid" do
      it 'does not create an talk_recruitment and returns 422' do
        expect {
          post admin_talk_recruitments_path, params: { 
            talk_recruitment: {
              title: "",
              site_url: talk_recruitment_site_url,
              start_at: talk_recruitment_start_at,
              end_at: talk_recruitment_end_at,
              status: talk_recruitment_status,
              event_id: talk_recruitment_event.id
            }
          }, headers: auth_headers
        }.not_to change { TalkRecruitment.count }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context "when no basic auth header is provided" do
      it "does not create an talk_recruitment and returns 401" do
        expect {
          post admin_talk_recruitments_path, params: { 
            talk_recruitment: {
              title: talk_recruitment_title,
              site_url: talk_recruitment_site_url,
              start_at: talk_recruitment_start_at,
              end_at: talk_recruitment_end_at,
              status: talk_recruitment_status,
              event_id: talk_recruitment_event.id
            }
          }
        }.not_to change { TalkRecruitment.count } 
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
