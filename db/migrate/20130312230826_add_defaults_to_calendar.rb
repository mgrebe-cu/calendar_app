class AddDefaultsToCalendar < ActiveRecord::Migration
  def change
    change_column :calendars, :color, :integer, :default => 0
    change_column :calendars, :displayed, :boolean, :default => true
  end
end
