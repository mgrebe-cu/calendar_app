class AddFieldsForCalSharing < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :events, :public, :boolean, default: false

    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :calendar_id
      t.boolean :subscribed, :default => false
      t.integer :color, :default => 0
      t.boolean :rw, :default => false

      t.timestamps
    end

    add_index :subscriptions, :user_id
    add_index :subscriptions, :calendar_id
    add_index :subscriptions, [:user_id, :calendar_id], unique: true
  end
end
