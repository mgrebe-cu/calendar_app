class AddFieldsToCalendar < ActiveRecord::Migration
  def change
    add_column :calendars, :description, :text
    add_column :calendars, :color, :integer
    add_column :calendars, :displayed, :boolean
  end
end
