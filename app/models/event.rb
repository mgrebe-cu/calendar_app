class Event < ActiveRecord::Base
    attr_accessible :title, :all_day, :calendar_id, :date, :end, :location, :notes, :start

    belongs_to :calendar

    validates :calendar_id, presence: true
    validates :title, presence: true
    validates :date, presence: true
    validates :start, presence: true, :if => lambda {|s| s.all_day == false }
    validates :end, presence: true, :if => lambda {|s| s.all_day == false }
    validate :end_cannot_be_before_start

    def end_cannot_be_before_start
        if !:all_day && :start > :end
            errors.add("Start time can't be after end time")
        end
    end

end
