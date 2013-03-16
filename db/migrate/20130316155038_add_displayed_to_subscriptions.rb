class AddDisplayedToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :displayed, :boolean, default: true
    add_column :subscriptions, :title, :string
  end
end
