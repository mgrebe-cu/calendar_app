class StartTimeValidator < ActiveModel::Validator
    def validate(record)
        if (!record.start_time.nil? and !record.end_time.nil?)
            if !record.all_day and record.start_time > record.end_time
                record.errors[:start_time] << "Start time can't be after end time"
            end
        end
    end
end

class Event < ActiveRecord::Base
    SHORT_LENGTH=15

    attr_accessible :title, :all_day, :calendar_id, :end_time, :location, :notes, 
                    :start_time, :start_date, :end_date

    belongs_to :calendar

    validates :calendar_id, presence: true
    validates :title, presence: true
    validates :start_time, presence: true, :if => lambda {|s| s.all_day == false }
    validates :end_time, presence: true, :if => lambda {|s| s.all_day == false }
    validates_with StartTimeValidator

    def when
        if self.all_day
            "<b>When:</b><br> All Day"
        else
            "<b>When:</b><br> From: " + self.start_time.strftime('%b %e %Y %I:%M %p') + 
            '<br>' + " To: " + self.end_time.strftime('%b %e %Y %I:%M %p')
        end
    end

    def where
        if self.location.nil? || self.location.size == 0
            ""
        else
            "<b>Where:</b><br> " + self.location + "<br>"
        end
    end

    def my_notes
        if self.notes.nil? || self.notes.size == 0
            ""
        else
            "<br><b>Notes:</b><br> " + self.notes
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
