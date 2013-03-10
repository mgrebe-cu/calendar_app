class ChangeTimeFormat < ActiveRecord::Migration
  def change
    remove_column :events, :start
    remove_column :events, :end
    add_column :events, :start, :datetime
    add_column :events, :end, :datetime
    remove_column :events, :date
  end
end
