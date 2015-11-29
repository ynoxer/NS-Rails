class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :address
      t.string :price
      t.string :expiration
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
