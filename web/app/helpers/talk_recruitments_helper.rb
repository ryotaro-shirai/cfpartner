module TalkRecruitmentsHelper
  STATUS_BADGES = {
    "no_information" => { label: "イベント情報公開", tone: "badge-neutral" },
    "published_information" => { label: "募集情報公開", tone: "badge-upcoming" },
    "now_on_call" => { label: "募集中", tone: "badge-open" },
    "finished_call" => { label: "募集終了", tone: "badge-closed" },
    "now_on_the_event" => { label: "イベント開催中", tone: "badge-now-on" },
    "after_the_event" => { label: "イベント終了", tone: "badge-done" },
  }.freeze

  def status_badge(talk_recruitment)
    if talk_recruitment.event.status == "now_on_the_event" || talk_recruitment.event.status == "after_the_event"
      status = talk_recruitment.event.status
    else
      status = talk_recruitment.status
    end
    STATUS_BADGES.fetch(status) { { label: "イベント情報公開", tone: "badge-neutral" } }
  end

  def days_left_until(talk_recruitment)
    return "締め切り情報なし" if talk_recruitment.end_at.nil?
    return "締め切り済み" if talk_recruitment.end_at < Time.current
    return "締め切りまで：#{(talk_recruitment.end_at.to_date - Time.current.to_date).to_i}日"
  end

  def formated_datetime(datetime, format = nil)
    return nil if datetime.nil?
    return l(datetime, format: format)
  end

end
