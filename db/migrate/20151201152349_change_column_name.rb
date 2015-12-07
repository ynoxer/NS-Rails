class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :rooms, :type, :state
    rename_column :users, :type, :state
  end
end
