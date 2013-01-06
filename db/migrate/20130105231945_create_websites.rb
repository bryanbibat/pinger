class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.string :name
      t.string :url
      t.integer :status_code
      t.string :status_message

      t.timestamps
    end
  end
end
