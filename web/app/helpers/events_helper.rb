module EventsHelper
  STATUS_BADGES = {
    "no_information" => { label: "情報なし", tone: "badge-neutral" },
    "before_call" => { label: "募集前", tone: "badge-upcoming" },
    "now_on_call" => { label: "募集中", tone: "badge-open" },
    "end_of_call" => { label: "募集終了", tone: "badge-closed" },
    "end_of_event" => { label: "イベント終了", tone: "badge-done" },
  }.freeze

  def cfp_status_badge(event)
    STATUS_BADGES.fetch(event.cfp_status) { { label: event.cfp_status, tone: "badge-neutral" } }
  end

  def target_url_by_event_status(event)
    case event.cfp_status
      when "no_information"
        return event.event_homepage_url
      when "before_call"
        return event.url
      when "now_on_call"
        return event.url
      when "end_of_call"
        return event.event_homepage_url
      when "end_of_event"
        return event.event_homepage_url
    end
  end

  def event_period_by_cfp_status(event)
    case event.cfp_status
      when "no_information"
        return "情報なし"
      when "before_call"
        return "#{l(event.cfp_start_at, format: :long)} 〜 #{l(event.cfp_end_at, format: :long)}"
      when "now_on_call"
        return "〜 #{l(event.cfp_end_at, format: :long)}まで"
      when "end_of_call"
        return "募集終了"
      when "end_of_event"
        return "募集終了"
    end
  end

  def days_left_until(date)
    return "情報なし" if date.nil?
    return "0日" if date < Time.current
    return "#{(date.to_date - Time.current.to_date).to_i}日"
  end

  def should_display_days_left_until_deadline?(event)
    case event.cfp_status
      when "no_information"
        return false
      when "before_call"
        return true
      when "now_on_call"
        return true
      when "end_of_call"
        return false
      when "end_of_event"
        return false
    end
  end
end
