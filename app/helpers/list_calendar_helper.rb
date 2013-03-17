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
  def list_calendar(date = Time.zone.now.to_date, events)
    ListCalendar.new(self, date, events).table
  end

  class ListCalendar < Struct.new(:view, :date, :events)
    delegate :content_tag, to: :view

    def table
      content_tag :table do
        rows = []
        events.each do |event|
          row = content_tag :tr do
            cols = []
            cell_class = "day_appointment " + calb_class(event.calendar)
            col = content_tag :td, :class => cell_class do 
              content_tag :a, :href => "/events/#{event.id}/edit", 
                :title => "#{event.title}",
                :data => {:toggle => "popover", 
                          :content => "#{event.where}#{event.when}#{event.my_notes}",
                          :true => "true",
                          :trigger => "hover",
                          :placement => "right",
                          :html => "true",
                          :remote => true },
                :class => "event-popover" do
                  content_tag :div, :class => "hide_extra" do
                    self.event_day_text(event)
                  end
              end              
            end
            cols << col
            col = content_tag :td, :class => cell_class do
              event.location
            end
            cols << col
            col = content_tag :td, :class => cell_class do
              event.start_time.strftime('%m/%d/%Y')
            end
            cols << col
            if event.all_day
              col = content_tag :td, :class => cell_class do
                "All Day"
              end
            else
              col = content_tag :td, :class => cell_class do
                event.start_time.strftime('%I:%M %p')
              end
            end
            cols << col
            col = content_tag :td, :class => cell_class do
              event.end_time.strftime('%m/%d/%Y')
            end
            cols << col
            if event.all_day
              col = content_tag :td, :class => cell_class do
                "All Day"
              end
            else
              col = content_tag :td, :class => cell_class do
                event.end_time.strftime('%I:%M %p')
              end
            end
            cols << col
            col = content_tag :td, :class => cell_class do
              event.notes
            end
            cols << col
            cols.join.html_safe
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
