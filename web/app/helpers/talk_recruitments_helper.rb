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

  # UI 用の締め切りバッジ情報
  def deadline_chip(talk_recruitment)
    return { label: "締め切り情報なし", tone: "deadline-muted" } if talk_recruitment.end_at.nil?
    return { label: "締め切り済み", tone: "deadline-closed" } if talk_recruitment.end_at < Time.current

    days = (talk_recruitment.end_at.to_date - Time.current.to_date).to_i
    if days.zero?
      { label: "本日締切", tone: "deadline-today" }
    elsif days <= 3
      { label: "あと#{days}日", tone: "deadline-soon" }
    else
      { label: "あと#{days}日", tone: "deadline-default" }
    end
  end

  def deadline_date(talk_recruitment)
    return "情報なし" if talk_recruitment.status == "no_information" || talk_recruitment.end_at.nil?
    return formatted_datetime(talk_recruitment.end_at, :long)
  end

  def event_date(event)
    start_date = event.start_at.to_date
    end_date = event.end_at.to_date

    return formatted_datetime(start_date) if start_date == end_date
    return "#{formatted_datetime(start_date)} ~ #{formatted_datetime(end_date)}"
  end

  private
    def formatted_datetime(datetime, format = nil)
      return nil if datetime.nil?
      return l(datetime, format: format)
    end

end
