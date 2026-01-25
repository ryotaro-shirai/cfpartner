require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validation' do

    context 'when start_at is before end_at' do
      let!(:event) { build :event }
      it 'is valid' do
        expect(event).to be_valid
      end
    end

    context 'when start_at is equal end_at' do
      start_at_and_end_at_time = rand(31..40).days.from_now
      let!(:event) { build(:event, start_at: start_at_and_end_at_time, end_at: start_at_and_end_at_time)}
      it 'is invalid' do
        expect(event).to be_invalid
        expect(event.errors[:start_at]).to include('は終了日時より前に設定してください')
      end
    end

    context 'when start_at after end_at' do
      let!(:event) { build(:event, start_at: rand(51..60).days.from_now)}
      it 'is invalid' do
        expect(event).to be_invalid
        expect(event.errors[:start_at]).to include('は終了日時より前に設定してください')
      end
    end

    context 'when start_at is nil' do
      let!(:event) { build(:event, start_at: nil)}
      it 'is valid' do
        expect(event).to be_valid
      end
    end

    context 'when end_at is nil' do
      let!(:event) { build(:event, end_at: nil)}
      it 'is valid' do
        expect(event).to be_valid
      end
    end
  end
end
