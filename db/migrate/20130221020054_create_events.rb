class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :calendar_id
      t.boolean :all_day
      t.date :date
      t.time :start
      t.time :end
      t.string :location
      t.text :notes

      t.timestamps
    end
    add_index :events, :calendar_id
  end
end
