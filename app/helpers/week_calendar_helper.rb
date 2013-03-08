# The module is rails helper for displaying a calendar
# week view.  It requires a collection of event objects
# passed in, as well as the date requested.
# The event objects are expected to have fields of
#  * title : string
#  * location : string
#  * start : datetime
#  * end :datetime
#  * all_day : boolean
#  * notes : strgin
#
# Author::    Mark Grebe  
# Copyright:: Copyright (c) 2013 Mark Grebe
# License::   Distributes under the same terms as Ruby
# Developed for Master of Engineering Project
# University of Colorado - Boulder - Spring 2013
include DayCalendarHelper

module WeekCalendarHelper
  def week_calendar(date = Date.today, events)
    WeekCalendar.new(self, date, events).table
  end

  class WeekCalendar < Struct.new(:view, :date, :events)
    delegate :content_tag, to: :view

    def table
      @start_date = date
      content_tag :table, :width => "100%" do
        content_tag :tr do
          days
        end
      end
    end

    def days
      days = [hours]
      (0..6).each do |day|
        days << day(@start_date + day.days, day)
      end
      days.join.html_safe
    end

    def hours
        content_tag :td, :width => "12%" do
            week_hour_column
        end
    end

    def day(this_day, day_index)
        content_tag :td, :width => "12%" do
            day_column(this_day, events[day_index])
        end
    end

  end
end
