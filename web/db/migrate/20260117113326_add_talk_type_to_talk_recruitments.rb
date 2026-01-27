class AddTalkTypeToTalkRecruitments < ActiveRecord::Migration[8.1]
  def change
    add_column :talk_recruitments, :talk_type, :integer
  end
end
