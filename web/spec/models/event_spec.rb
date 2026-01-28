require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validation' do

    context 'when start_at is before end_at' do
      let!(:start_at) { rand(31..40).days.from_now }
      let!(:end_at) { rand(41..50).days.from_now }
      let!(:event) { build(:event, start_at: start_at, end_at: end_at) }
      it 'is valid' do
        expect(event).to be_valid
      end
    end

    context 'when start_at is equal end_at' do
      let!(:start_at_and_end_at_time) { rand(31..40).days.from_now }
      let!(:event) { build(:event, start_at: start_at_and_end_at_time, end_at: start_at_and_end_at_time)}
      it 'is invalid' do
        expect(event).to be_invalid
        expect(event.errors[:start_at]).to include('は終了日時より前に設定してください')
      end
    end

    context 'when start_at after end_at' do
      let!(:start_at) { rand(41..50).days.from_now }
      let!(:end_at) { rand(31..40).days.from_now }
      let!(:event) { build(:event, start_at: start_at, end_at: end_at) }
      it 'is invalid' do
        expect(event).to be_invalid
        expect(event.errors[:start_at]).to include('は終了日時より前に設定してください')
      end
    end

    context 'when start_at is nil' do
      let!(:start_at) { nil }
      let!(:end_at) { rand(31..40).days.from_now }
      let!(:event) { build(:event, start_at: start_at, end_at: end_at) }
      it 'is invalid' do
        expect(event).to be_invalid
        expect(event.errors[:start_at]).to include('を入力してください')
      end
    end

    context 'when end_at is nil' do
      let!(:start_at) { rand(41..50).days.from_now }
      let!(:end_at) { nil }
      let!(:event) { build(:event, start_at: start_at, end_at: end_at) }
      it 'is invalid' do
        expect(event).to be_invalid
        expect(event.errors[:end_at]).to include('を入力してください')
      end
    end
  end
end
