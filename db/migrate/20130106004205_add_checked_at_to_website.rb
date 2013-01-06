class AddCheckedAtToWebsite < ActiveRecord::Migration
  def change
    add_column :websites, :checked_at, :datetime
  end
end
