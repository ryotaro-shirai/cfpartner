class ChangeTalkTypeNotNull < ActiveRecord::Migration[8.1]
  def change
    change_column_null :talk_recruitments, :talk_type, false
  end
end
