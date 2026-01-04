class ChangeColumnsNotNull < ActiveRecord::Migration[8.1]
  def change
    change_column_null :events, :event_homepage_url, false
    change_column_null :events, :event_start_at, false
    change_column_null :events, :event_end_at, false
  end
end
