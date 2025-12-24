class AddColumnImageUrlToEvent < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :image_url, :string
  end
end
