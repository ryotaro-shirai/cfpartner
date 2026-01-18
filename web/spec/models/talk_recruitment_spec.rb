require 'rails_helper'

RSpec.describe TalkRecruitment, type: :model do
  describe "validation" do
    context "start_at が end_at よりも前の場合" do
      let!(:talk_recruitment) { build :talk_recruitment }
      it "is valid" do
        expect(talk_recruitment).to be_valid
      end
    end

    context "start_at が end_at よりも後の場合" do
      let!(:talk_recruitment) { build(:talk_recruitment, end_at: rand(1..10).days.from_now)}
      it "is invalid" do
        expect(talk_recruitment).to be_invalid
      end
    end

    context "start_at が end_at と同じ場合" do
      it "is invalid" do
      end
    end

    context "start_at が nil の場合" do
      let!(:talk_recruitment) { build(:talk_recruitment, start_at: nil)}
      it "is valid" do
        expect(talk_recruitment).to be_valid
      end
    end

    context "end_at が nil の場合" do
      let!(:talk_recruitment) { build(:talk_recruitment, end_at: nil)}
      it "is valid" do
        expect(talk_recruitment).to be_valid
      end
    end
  end
end
