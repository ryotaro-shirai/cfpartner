class TalkRecruitment < ApplicationRecord
  belongs_to :event

  validates :title, length: { maximum: 50 }, presence: true
  validate :recruitment_start_at_should_be_before_end_at

  enum :status, {
    no_information: 1,
    published_information: 2, # 募集情報公開
    now_on_call: 3, # 募集中
    finished_call: 4 # 募集終了
  }, default: 1

  enum :talk_type, {
    session: 1, # セッション
    short_session: 2, # ショートセッション
    lightning_talk: 3, # LT
    other: 4 # その他
  }, default: 1

  private

  def recruitment_start_at_should_be_before_end_at
    return if start_at.nil? || end_at.nil?
    if start_at >= end_at
      errors.add(:start_at, "は終了日時より前に設定してください")
    end
  end
end
