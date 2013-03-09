# The module is rails helper for displaying a calendar
# day view.  It requires a collection of event objects
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
module ListCalendarHelper
  def list_calendar(date = Date.today, events)
    ListCalendar.new(self, date, events).table
  end

  class ListCalendar < Struct.new(:view, :date, :events)
    delegate :content_tag, to: :view

    def table
      content_tag :table do
        rows = []
        events.each do |event|
          row = content_tag :tr do
            col1 = content_tag :td do
              event.title
            end
            col2 = content_tag :td do
              event.location
            end
            col3 = content_tag :td do
              event.start_time.strftime('%m/%d/%Y')
            end
            col4 = content_tag :td do
              event.start_time.strftime('%I:%M %p')
            end
            col5 = content_tag :td do
              event.end_time.strftime('%m/%d/%Y')
            end
            col6 = content_tag :td do
              event.end_time.strftime('%I:%M %p')
            end
            col7 = content_tag :td do
              event.notes
            end
            [col1, col2, col3, col4, col5, col6, col7].join.html_safe
          end
          rows << row
        end
        rows.join.html_safe
      end
    end

    # This method produces text for an event with highlighting to 
    #  be displayed on a single line
    def event_day_text(event)
      text = "<b>" + event.short_title + "</b>" 
      text.html_safe
    end

  end
end
