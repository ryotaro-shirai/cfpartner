class RemoveColumnsFromEvents < ActiveRecord::Migration[8.1]
  def change
    remove_column :events, :deprecated_cfp_start_at
    remove_column :events, :deprecated_cfp_end_at
    remove_column :events, :deprecated_cfp_site_url
  end
end
