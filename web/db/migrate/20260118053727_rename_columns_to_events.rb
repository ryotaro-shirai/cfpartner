class RenameColumnsToEvents < ActiveRecord::Migration[8.1]
  def change
    rename_column :events, :cfp_status, :status
    rename_column :events, :event_homepage_url, :site_url
    rename_column :events, :cfp_start_at, :deplicated_cfp_start_at
    rename_column :events, :cfp_end_at, :deplicated_cfp_end_at
    rename_column :events, :event_start_at, :start_at
    rename_column :events, :event_end_at, :end_at
    rename_column :events, :image_url, :thumbnail_url
    rename_column :events, :url, :deplicated_cfp_site_url
  end
end
