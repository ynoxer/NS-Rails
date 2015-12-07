class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.date :from
      t.date :to
      t.references :user, index: true, foreign_key: true
      t.references :room, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
