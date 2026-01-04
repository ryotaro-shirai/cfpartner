class AddDetailsToEvent < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :event_homepage_url, :string
    add_column :events, :event_start_at, :datetime
    add_column :events, :event_end_at, :datetime
  end
end
