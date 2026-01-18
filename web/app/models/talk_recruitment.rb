class TalkRecruitment < ApplicationRecord
  belongs_to :event

  validates :title, length: { maximum: 50 }, presence: true
  validates :site_url, presence: true 
  validates :status, presence: true
  validate :recruitment_start_at_should_be_before_end_at

  enum :status, {
    no_information: 0, # 情報なし
    before_call: 1, # CfP募集前
    now_on_call: 2, # CfP募集中
    end_of_call: 3, # CfP募集終了
    end_of_event: 4, # イベント終了
  }, default: 0

  enum :talk_type, {
    session: 1, # セッション
    short_session: 2, # ショートセッション
    lightning_talk: 3, # LT
    other: 4, # その他
  }, default: 1

  private

  def recruitment_start_at_should_be_before_end_at
    return if start_at.nil? || end_at.nil?
    if start_at >= end_at
      errors.add(:start_at, "は終了日時より前に設定してください")
    end
  end
end
