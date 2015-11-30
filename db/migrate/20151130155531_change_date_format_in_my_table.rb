class ChangeDateFormatInMyTable < ActiveRecord::Migration
  def up
    change_column :rooms, :expiration, :datetime
  end

  def down
    change_column :rooms, :expiration, :string
  end
end
