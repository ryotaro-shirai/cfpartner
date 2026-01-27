class Event < ApplicationRecord
  has_one_attached :image
  has_many :talk_recruitments

  validates :name, length: { maximum: 50 }, presence: true
  validates :status, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true 
  validate :event_start_at_should_be_before_end_at

  enum :status, {
    published_information: 1, # イベント情報公開
    now_on_the_event: 2, # イベント開催中
    after_the_event: 3, # イベント終了
  }, default: 1

  private

  def event_start_at_should_be_before_end_at
    if start_at >= end_at
      errors.add(:start_at, "は終了日時より前に設定してください")
    end
  end
end
