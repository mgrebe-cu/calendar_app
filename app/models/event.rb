class Event < ActiveRecord::Base
    attr_accessible :title, :all_day, :calendar_id, :date, :end, :location, :notes, :start

    belongs_to :calendar

    validates :calendar_id, presence: true
    validates :title, presence: true
    validates :date, presence: true
    validates :all_day, presence: true
    validates :start, presence: true, :if => lambda {|s| s.all_day == false }
    validates :end, presence: true, :numericality => {:greater_than => :start}, :if => lambda {|s| s.all_day == false }
end
