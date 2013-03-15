class AddIndexToEvents < ActiveRecord::Migration
  def change
    add_index :events, [:start_time, :end_time]
  end
end
