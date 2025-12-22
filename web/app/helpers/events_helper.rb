module EventsHelper
  STATUS_BADGES = {
    "before_call" => { label: "CfP募集前", tone: "badge-upcoming" },
    "now_on_call" => { label: "CfP募集中", tone: "badge-open" },
    "end_of_call" => { label: "CfP募集終了", tone: "badge-closed" },
    "end_of_event" => { label: "イベント終了", tone: "badge-done" },
  }.freeze

  def cfp_status_badge(event)
    STATUS_BADGES.fetch(event.cfp_status) { { label: event.cfp_status, tone: "badge-neutral" } }
  end
end
