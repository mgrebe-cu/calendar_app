class Event < ActiveRecord::Base
    SHORT_LENGTH=15

    attr_accessible :title, :all_day, :calendar_id, :end_time, :location, :notes, 
                    :start_time, :start_date, :end_date

    belongs_to :calendar

    validates :calendar_id, presence: true
    validates :title, presence: true
    validates :start_time, presence: true, :if => lambda {|s| s.all_day == false }
    validates :end_time, presence: true, :if => lambda {|s| s.all_day == false }
    validate :end_cannot_be_before_start

    def end_cannot_be_before_start
        if !:all_day && :start_time > :end_time
            errors.add("Start time can't be after end time")
        end
    end

    def when
        if self.all_day
            "When: All Day"
        else
            "When: From " + self.start_time.strftime('%I:%M %p') + 
            " To " + self.end_time.strftime('%I:%M %p')
        end
    end

    def where
        if self.location.nil? || self.location.size == 0
            ""
        else
            "Where: " + self.location + "<br>"
        end
    end

    def my_notes
        if self.notes.nil? || self.notes.size == 0
            ""
        else
            "<br>Notes: " + self.notes
        end
    end

    def short_title
        if self.title.size > SHORT_LENGTH
            self.title[0..11] + '...'
        else
            self.title
        end
    end

end
