class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.boolean :default
      t.integer :user_id

      t.timestamps
    end
    add_index :calendars, :user_id
  end
end
