require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#cfp_start_at_should_be_before_end_at' do
    
    let(:current_time) { Time.current }
    let(:event) { Event.new(
      name: "test_name",
      url: "test_url",
      cfp_status: 1,
      cfp_start_at: current_time.ago(1.day),
      cfp_end_at: current_time.since(1.day)
    ) }

    context 'when cfp_start_at is before cfp_end_at' do
      it 'is valid' do
        expect(event).to be_valid
      end
    end

    context 'when cfp_start_at is equal cfp_end_at' do
      it 'is invalid' do
        event.cfp_start_at = current_time.since(1.day)
        expect(event).to be_invalid
        expect(event.errors[:cfp_start_at]).to include('は終了日時より前に設定してください')
      end
    end

    context 'when cfp_start_at after equal cfp_end_at' do
      it 'is invalid' do
        event.cfp_start_at = current_time.since(2.day)
        expect(event).to be_invalid
        expect(event.errors[:cfp_start_at]).to include('は終了日時より前に設定してください')
      end
    end

    context 'when cfp_start_at is nil' do
      it 'is valid' do
        event.cfp_start_at = nil
        expect(event).to be_valid
      end
    end

    context 'when cfp_end_at is nil' do
      it 'is valid' do
        event.cfp_end_at = nil
        expect(event).to be_valid
      end
    end
  end
end
