class AddViewToUsers < ActiveRecord::Migration
  def change
    add_column :users, :default_view, :integer, default: 0
  end
end
