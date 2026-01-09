class Event < ApplicationRecord
  has_one_attached :image
  validates :name, length: { maximum: 50 }, presence: true
  validates :url, presence: true
  validates :cfp_status, presence: true
  validate :cfp_start_at_should_be_before_end_at
  validate :event_start_at_should_be_before_end_at

  enum :cfp_status, {
    before_call: 0, # CfP募集前
    now_on_call: 1, # CfP募集中
    end_of_call: 2, # CfP募集終了
    end_of_event: 3, # イベント終了
  }, default: 0

  private

  def cfp_start_at_should_be_before_end_at
    return if cfp_start_at.nil? || cfp_end_at.nil?
    if cfp_start_at >= cfp_end_at
      errors.add(:cfp_start_at, "は終了日時より前に設定してください")
    end
  end

  def event_start_at_should_be_before_end_at
    return if event_start_at.nil? || event_end_at.nil?
    if event_start_at >= event_end_at
      errors.add(:event_start_at, "は終了日時より前に設定してください")
    end
  end
end
