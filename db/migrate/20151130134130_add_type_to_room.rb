class AddTypeToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :type, :string
  end
end
