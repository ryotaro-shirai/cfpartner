class TypoColumnsToEvents < ActiveRecord::Migration[8.1]
  def change
    rename_column :events, :deplicated_cfp_start_at, :deprecated_cfp_start_at
    rename_column :events, :deplicated_cfp_end_at, :deprecated_cfp_end_at
    rename_column :events, :deplicated_cfp_site_url, :deprecated_cfp_site_url
  end
end
