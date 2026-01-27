class CreateTalkRecruitments < ActiveRecord::Migration[8.1]
  def change
    create_table :talk_recruitments do |t|
      t.string :title, null: false
      t.string :recruitment_url, null: false
      t.integer :recruitment_status, null: false
      t.datetime :recruitment_start_at
      t.datetime :recruitment_end_at
      t.references :event, null: false, foreign_key: true
      t.timestamps
    end
  end
end
