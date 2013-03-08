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
module DayCalendarHelper
  def day_calendar(date = Date.today, events)
    DayCalendar.new(self, date, events).table
  end

  def day_column(date = Date.today, events)
    DayCalendar.new(self, date, events).column
  end

  def week_hour_column
    DayCalendar.new(self, Date.today, nil).hour_column
  end

  class DayCalendar < Struct.new(:view, :date, :events)
    delegate :content_tag, to: :view

    NUM_HALF_HOURS = 24*2

    def setup
      @max_cols = calc_max_cols(0, NUM_HALF_HOURS)
      @max_cols = 1 if @max_cols ==0
      @col_width = (100.0/@max_cols + 0.5).to_i
      calc_event_rows
      @col_event = {}
    end

    # Draw the day calendar table
    def table
      setup
      content_tag :div do
        all_day_table + hour_table
      end
    end

    # Draw a day column for the week view
    def column
      setup
      content_tag :div, :class => "day_col_div" do
        content_tag :table, :width => "100%" do
          event_rows
        end
      end
    end

    # Draw a day column for the week view
    def hour_column
      content_tag :div, :class => "day_col_div" do
        content_tag :table, :width => "100%" do
          hour_rows
        end
      end
    end

    # Draw the table that contains the all day events
    def all_day_table
      content_tag :table, :width => "100%" do
        header_all_day + all_day_events
      end
    end
 
    # Draw the table that contains the day events
    def hour_table
      content_tag :div, :class => "day_div" do
        content_tag :table do
          header + time_body
        end
      end
    end

    # Calculate the maximum number of rows that are required in the
    #  calendar table. 
    def calc_max_cols(row, rowspan)
      max = 0
      (row..(row+rowspan-1)).each do |half_hour|
        # Set the row time boundaries so that an event must extend
        # into the row, not just start or end on the boundary.
        row_time_start = date.midnight + half_hour * 30 * 60 + 1
        row_time_end = row_time_start + 30 * 60 - 2
        cols = calc_time_cols(row_time_start, row_time_end)
        if cols > max
          max = cols
        end
      end
      max
    end

    # Calculate the number of columns that are required for a
    #  particular row in the table.
    def calc_time_cols(row_time_start, row_time_end)
      cols = 0
      if !events.nil?
        events.each do |event|
          if event.start_time <= row_time_end && event.end_time >= row_time_start
            cols = cols + 1 
          end
        end
      end
      cols
    end

    # Create hashs which hold the rows that events start and end it,
    #  as well as how many rows they span
    def calc_event_rows
      @events_start = {}
      @events_end = {}
      @event_span = {}
      if !events.nil?
        events.each do |event|
          if !event.all_day
            start_row = (event.start_time.seconds_since_midnight / (60*30)).to_i
            if @events_start.member?(start_row)
              @events_start[start_row] << event
            else
              @events_start[start_row] = [event]
            end
            end_row = ((event.end_time.seconds_since_midnight-1) / (60*30)).to_i
            if @events_end.member?(end_row)
              @events_end[end_row] << event
            else
              @events_end[end_row] = [event]
            end
            @event_span[event] = end_row - start_row + 1
          end
        end
      end
    end

    # Display the all day events in the table
    def all_day_events
      rows = []
      if !events.nil?
        events.each do |event|
          if event.all_day
            row = content_tag :tr do
              content_tag :td, :colspan => "2", 
                  :max => {:height => "15px"},
                  :overflow => "hidden",
                  :class => "day_all_event" do
                content_tag :a, :href => "/events/#{event.id}/edit", 
                  :title => "#{event.title}",
                  :data => {:toggle => "popover", 
                          :content => "#{event.where}#{event.when}#{event.my_notes}",
                          :true => "true",
                          :trigger => "hover",
                          :placement => "left",
                          :remote => true },
                  :class => "event-popover" do
                    self.event_day_text(event)
                end
              end
            end
            rows << row
          end
        end
      end
      content_tag :tr do
        rows.join.html_safe
      end
    end

    # Draw the header for the day calendar table
    def header
      content_tag :tr do
        c1 = content_tag :th, :width => "1%", :colspan => "2", 
            :class => "day_header"  do
              'Time' 
        end
        c2 = content_tag :th, :style => "width: 100%", :width => "100%", 
            :colspan => @max_cols.to_s, :class => "day_header" do
              ''
        end
        c1 + c2
      end
    end

    # Draw the header for the all day events
    def header_all_day
      content_tag :tr do
        content_tag :th, :width => "100%", 
            :class => "day_header" do
          'All Day Events'
        end
      end
    end

    # Wrap the event table in a body
    def time_body
      content_tag :tbody do
        time_rows
      end
    end

    # Draw all of the rows in the calendar table
    def time_rows
      rows = []
      (0..NUM_HALF_HOURS-1).each do |half_hour|
        row = content_tag :tr do
          [hour_cell(half_hour), minute_cell(half_hour), 
            event_cells(half_hour)].join.html_safe
        end
        rows << row
      end
      rows.join.html_safe
    end

    # Draw all of the rows in the calendar column for week view
    def hour_rows
      rows = []
      (0..NUM_HALF_HOURS-1).each do |half_hour|
        row = content_tag :tr do
          [hour_cell(half_hour), minute_cell(half_hour)].join.html_safe
        end
        rows << row
      end
      rows.join.html_safe
    end

    # Draw all of the rows in the calendar column for week view
    def event_rows
      rows = []
      (0..NUM_HALF_HOURS-1).each do |half_hour|
        row = content_tag :tr do
          event_cells(half_hour)
        end
        rows << row
      end
      rows.join.html_safe
    end

    # Draw the hour cell with the hour text
    def hour_cell(half_hour)
      if half_hour % 2 == 0
        content_tag :td, :class => "day_hour_cell", 
              :width => "1%", :rowspan => 2 do
          if (half_hour/2 == 0)
            ''
          elsif (half_hour/2 < 12)
            (half_hour/2).to_s + 'am'
          elsif (half_hour/2 == 12)
            'Noon'
          elsif (half_hour/2 > 12)
            ((half_hour/2) - 12).to_s + 'pm'
          end
        end
      else
        nil
      end
    end

    # Draw the half hour cell with either 00 or 30 minutes
    def minute_cell(half_hour)
      content_tag :td, :class => "day_min_cell" do
        if (half_hour%2 == 0)
          '00'
        else
          '30'
        end
      end
    end

    # Draw the event/free time cells
    def event_cells(half_hour)
      cols = []
      free_count = 1
      for col in 0..(@max_cols-1) do
        # If the column is empty
        if !@col_event.member?(col)
          # See if an event starts in this row and fill it in
          if @events_start.member?(half_hour)
            # Remove event start from list
            event = @events_start[half_hour].delete_at(0)
            if @events_start[half_hour].size == 0
              @events_start.delete(half_hour)
            end
            # Find the number of columns it can take
            max = calc_max_cols(half_hour, @event_span[event]) - 1
            my_cols = @max_cols - max
            for rescol in col..(col+my_cols-1) do
              # Reserve column for event
              @col_event[rescol] = event
            end
            # Add event tags
            newcol = content_tag :td, 
                :height => (@event_span[event]*15).to_s + "px",
                :class => "day_appointment", 
                :colspan => my_cols.to_s, 
                :rowspan => @event_span[event].to_s,
                :width =>  @col_width.to_s + '%' do
              content_tag :a, :href => "/events/#{event.id}/edit", 
                :title => "#{event.title}",
                :data => {:toggle => "popover", 
                          :content => "#{event.where}#{event.when}#{event.my_notes}",
                          :true => "true",
                          :trigger => "hover",
                          :placement => "left",
                          :html => "true",
                          :remote => true },
                :class => "event-popover" do
                  content_tag :div, :class => "hide_extra" do
                    self.event_day_text(event)
                  end
              end              
            end
            cols << newcol
          # Otherwise it is free time in this column
          else
            # If this is the last column of free time
            if col == @max_cols-1 || @col_event.member?(col+1)
              # Add the free time tag
              newcol = content_tag :td, 
                  :class => "day_free_time", 
                  :colspan => free_count.to_s,
                  :width => (@col_width).to_s + '%' do
                ''
              end
              cols << newcol
              free_count = 1
            # Otherwise incease the count of free columns
            else
              free_count = free_count + 1
            end
          end
        end
      end
      # Check if any events end in this row
      if @events_end.member?(half_hour)
        @events_end[half_hour].each do |event|
          # Find the column the ending event is in
          for col in 0..(@max_cols-1) do
            if @col_event.member?(col)
              if @col_event[col] == event
                # And remove the event from the column
                @col_event.delete(col)
              end
            end
          end
        end
      end
      cols.join.html_safe
    end

    # This method produces text for an event with highlighting to 
    #  be displayed on a single line
    def event_day_text(event)
      text = "<b>" + event.title + "</b>" 
      if !event.location.nil?
        if event.location.size > 0
          text += " -  <b>Location:</b> " + event.location
        end
      end
      if !event.all_day
        text += " - <b>When:</b> From " + 
        event.start_time.strftime('%I:%M %p') + 
          " To " + event.end_time.strftime('%I:%M %p') 
      end              
      text.html_safe
    end

  end
end
