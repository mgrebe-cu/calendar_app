class ChangeTimeFormat < ActiveRecord::Migration
  def change
    change_column :events, :start, :datetime
    change_column :events, :end, :datetime
    remove_column :events, :date
  end
end
