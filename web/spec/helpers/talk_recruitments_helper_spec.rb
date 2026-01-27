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
  include ActiveSupport::Testing::TimeHelpers

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

    context "when talk recruitment has passed end_at" do
      let!(:start_at){ Time.current.ago(2.days) }
      let!(:end_at){ Time.current.ago(1.day) }
      let!(:talk_recruitment){ create(:talk_recruitment, start_at: start_at, end_at: end_at)}
      it "return 締め切り済み" do
        expect(helper.days_left_until(talk_recruitment)).to eq "締め切り済み"
      end
    end

    context "when talk recruitment hasn't passed end_at" do
      let!(:start_at){ Time.current.ago(2.days) }
      let!(:end_at){ Time.current.since(1.days) }
      let!(:talk_recruitment){ create(:talk_recruitment, start_at: start_at, end_at: end_at)}
      it "return 締め切りまで" do
        expect(helper.days_left_until(talk_recruitment)).to eq "締め切りまで：1日"
      end
    end
  end

  describe "#deadline_chip" do
    around do |example|
      travel_to(Time.zone.local(2026, 1, 1, 12, 0, 0)) { example.run }
    end

    context "when end_at is nil" do
      let!(:talk_recruitment){ create(:talk_recruitment, end_at: nil) }
      it "returns info none chip" do
        expect(helper.deadline_chip(talk_recruitment)).to eq({ label: "締め切り情報なし", tone: "deadline-muted" })
      end
    end

    context "when end_at has passed" do
      let!(:talk_recruitment){ create(:talk_recruitment, start_at: 2.days.ago, end_at: 1.day.ago) }
      it "returns closed chip" do
        expect(helper.deadline_chip(talk_recruitment)).to eq({ label: "締め切り済み", tone: "deadline-closed" })
      end
    end

    context "when deadline is today" do
      let!(:talk_recruitment){ create(:talk_recruitment, start_at: 1.day.ago, end_at: Time.current.change(hour: 23, min: 59)) }
      it "returns today chip" do
        expect(helper.deadline_chip(talk_recruitment)).to eq({ label: "本日締切", tone: "deadline-today" })
      end
    end

    context "when deadline is within 3 days" do
      let!(:talk_recruitment){ create(:talk_recruitment, start_at: 1.day.ago, end_at: 2.days.from_now) }
      it "returns soon chip" do
        expect(helper.deadline_chip(talk_recruitment)).to eq({ label: "あと2日", tone: "deadline-soon" })
      end
    end

    context "when deadline is after 3 days" do
      let!(:talk_recruitment){ create(:talk_recruitment, start_at: 1.day.ago, end_at: 5.days.from_now) }
      it "returns default chip" do
        expect(helper.deadline_chip(talk_recruitment)).to eq({ label: "あと5日", tone: "deadline-default" })
      end
    end
  end

  describe "#deadline_date" do
    context "when talk_recruitment.status is no_information" do
      let!(:talk_recruitment){ create(:talk_recruitment, status: :no_information)}
      it "return 情報なし" do
        expect(helper.deadline_date(talk_recruitment)).to eq "情報なし"
      end
    end

    context "when talk_recruitment.status isn't no_information" do
      let!(:end_at){ Time.new(2026, 1, 26, 12, 30, 45) }
      let!(:talk_recruitment){ create(:talk_recruitment, status: :now_on_call, start_at: end_at.ago(10.days), end_at: end_at)}
      it "return long format deadline date" do
        expect(helper.deadline_date(talk_recruitment)).to eq "2026/01/26 12:30"
      end
    end
  end

  describe "#event_date" do

    context "when start_at.date is equal end_at.date" do
      let!(:start_at){ Time.new(2026, 1, 26, 12, 30, 45) }
      let!(:end_at){ start_at.since(1.hour) }
      let!(:event){ create(:event, start_at: start_at, end_at: end_at)}
      it "return date" do
        expect(helper.event_date(event)).to eq "2026/01/26"
      end
    end

    context "when start_at.date is not equal end_at.date" do
      let!(:start_at){ Time.new(2026, 1, 26, 12, 30, 45) }
      let!(:end_at){ start_at.since(2.days) }
      let!(:event){ create(:event, start_at: start_at, end_at: end_at)}
      it "return period" do
        expect(helper.event_date(event)).to eq "2026/01/26 ~ 2026/01/28"
      end
    end
  end
end
