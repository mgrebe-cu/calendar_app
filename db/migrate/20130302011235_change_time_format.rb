class ChangeTimeFormat < ActiveRecord::Migration
  def change
    remove_column :events, :start, :datetime
    remove_column :events, :end, :datetime
    add_column :events, :start
    add_column :events, :end
    remove_column :events, :date
  end
end
