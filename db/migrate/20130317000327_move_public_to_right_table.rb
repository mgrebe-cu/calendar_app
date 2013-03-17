class MovePublicToRightTable < ActiveRecord::Migration
  def change
    remove_column :events, :public 
    add_column :calendars, :public, :boolean, default: false
  end

end
