class ChangeTalkTypeNull < ActiveRecord::Migration[8.1]
  def change
    change_column_null :talk_recruitments, :talk_type, true
    change_column_null :talk_recruitments, :site_url, true
  end
end
