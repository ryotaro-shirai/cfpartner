class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.integer :cfp_status, null: false
      t.datetime :cfp_start_at
      t.datetime :cfp_end_at

      t.timestamps
    end
  end
end
