require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TalkRecruitmentsHelper. For example:
#
# describe TalkRecruitmentsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TalkRecruitmentsHelper, type: :helper do
  describe "#status_badge" do

    context "when event information is published" do
      let!(:talk_recruitment){ create :talk_recruitment, :no_information}
      it "return published event information hash" do
        expect(helper.status_badge(talk_recruitment)).to eq({ label: "イベント情報公開", tone: "badge-neutral" })
      end
    end

    context "when talk recruitment information is published" do
      let!(:talk_recruitment){ create(:talk_recruitment)}
      it "return published talk recruitment information hash" do
        expect(helper.status_badge(talk_recruitment)).to eq({ label: "募集情報公開", tone: "badge-upcoming" })
      end
    end

    context "when talk recruitment is now on call" do
      let!(:talk_recruitment){ create(:talk_recruitment, :now_on_call)}
      it "return talk recruitment now on call hash" do
        expect(helper.status_badge(talk_recruitment)).to eq({ label: "募集中", tone: "badge-open" })
      end
    end

    context "when talk recruitment is finished" do
      let!(:talk_recruitment){ create(:talk_recruitment, :finished_call)}
      it "return talk recruitment finished hash" do
        expect(helper.status_badge(talk_recruitment)).to eq({ label: "募集終了", tone: "badge-closed" })
      end
    end

    context "when talk recruitment is finished and the event is now on" do
      let!(:talk_recruitment){ create(:talk_recruitment, :finished_call, event: create(:event, :now_on_the_event))}
      it "return now on the event hash" do
        expect(helper.status_badge(talk_recruitment)).to eq({ label: "イベント開催中", tone: "badge-now-on" })
      end
    end

    context "when talk recruitment and event is finished" do
      let!(:talk_recruitment){ create(:talk_recruitment, :finished_call, event: create(:event, :after_the_event))}
      it "return after the event hash" do
        expect(helper.status_badge(talk_recruitment)).to eq({ label: "イベント終了", tone: "badge-done" })
      end
    end
  end

  describe "#days_left_until" do
    context "when talk recruitment doesn't have end_at" do
      let!(:talk_recruitment){ create(:talk_recruitment, end_at: nil)}
      it "return 締め切り情報なし" do
        expect(helper.days_left_until(talk_recruitment)).to eq "締め切り情報なし"
      end
    end

    context "when talk recruitment has end_at and has passed end_at" do
      let!(:talk_recruitment){ create(:talk_recruitment, start_at:  Time.current.ago(1.day), end_at: Time.current.ago(1.hour))}
      it "return 締め切り済み" do
        expect(helper.days_left_until(talk_recruitment)).to eq "締め切り済み"
      end
    end

    context "when talk recruitment has end_at and hasn't passed end_at" do
      let!(:talk_recruitment){ create(:talk_recruitment, start_at:  Time.current.ago(1.day), end_at: Time.current.since(5.days))}
      it "return 締め切りまで" do
        expect(helper.days_left_until(talk_recruitment)).to eq "締め切りまで：5日"
      end
    end
  end

  describe "#formated_datetime" do
    context "when datetime is nil" do
      it "return nil" do
        expect(helper.formated_datetime(nil)).to eq nil
      end
    end

    context "when datetime is not nil and give format" do
      let!(:datetime){Time.new(2026, 1, 26, 12, 30, 45)}
      let!(:format){:long}
      it "return long format datetime" do
        expect(helper.formated_datetime(datetime, format)).to eq "2026/01/26 12:30"
      end
    end

    context "when datetime is not nil and don't give format" do
      let!(:datetime){Time.new(2026, 1, 26, 12, 30, 45)}
      let!(:format){nil}
      it "return long format datetime" do
        expect(helper.formated_datetime(datetime, format)).to eq "2026年01月26日(月) 12時30分45秒 +0900"
      end
    end
  end
end
