class RenameColumnsToTalkRecruitments < ActiveRecord::Migration[8.1]
  def change
    rename_column :talk_recruitments, :recruitment_url, :site_url
    rename_column :talk_recruitments, :recruitment_status, :status
    rename_column :talk_recruitments, :recruitment_start_at, :start_at
    rename_column :talk_recruitments, :recruitment_end_at, :end_at
  end
end
