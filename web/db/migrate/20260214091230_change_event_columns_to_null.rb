class ChangeEventColumnsToNull < ActiveRecord::Migration[8.1]
  def change
    change_column_null :events, :deprecated_cfp_site_url, true
  end
end
