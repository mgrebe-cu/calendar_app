# The module is a rails helper for displaying a calendar
# week view, either a single day or multiple days for a
# week or work week view.  It requires a collection of 
# event objects passed in, as well as the date requested.
# The event objects are expected to have fields of
#  * title : string
#  * location : string
#  * start : datetime
#  * end :datetime
#  * all_day : boolean
#  * notes : string
#
# Author::    Mark Grebe  
# Copyright:: Copyright (c) 2013 Mark Grebe
# License::   Distributes under the same terms as Ruby
# Developed for Master of Engineering Project
# University of Colorado - Boulder - Spring 2013
include CalendarsHelper

module WeekCalendarHelper
  def week_calendar(date = Time.zone.now.to_date, num_days, events, params, user)
    if num_days == 7
        cal_date = date.beginning_of_week(:sunday)
    else
        cal_date = date
    end
    WeekCalendar.new(self, cal_date, num_days, events, params, user).table
  end

  class WeekCalendar < Struct.new(:view, :date, :num_days, :events, :params, :user)
    HEADER = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]

    delegate :content_tag, to: :view
    delegate :url_for, to: :view

    NUM_HALF_HOURS = 24*2
    
    # Draw the day calendar table
    def table
      @max_cols = []
      @col_width = []
      @col_event = []
      (0..(num_days-1)).each do |day|
        @max_cols[day] = calc_max_cols(0, NUM_HALF_HOURS,day)
        if @max_cols[day] == 0
            @max_cols[day] = 1
        end
        @col_width[day] = (100.0/(num_days*@max_cols[day]) + 0.5).to_i
        @col_event << {}
      end
      @all_day_max = calc_all_day_max
      calc_event_rows
      content_tag :div do
        all_day_table + hour_table
      end
    end

    # Draw the table that contains the all day events
    def all_day_table
      content_tag :div, :class => "daytitle" do
        content_tag :table, :class => "day_table", :width => "98%" do
          header_all_day + all_day_events
        end
      end
    end
 
    # Draw the table that contains the day events
    def hour_table
      content_tag :div, :class => "day_div" do
        content_tag :table, :class => "day_table" do
          header + time_body
        end
      end
    end

    # Calculate the maximum number of rows that are required in the
    #  calendar table. 
    def calc_max_cols(row, rowspan,day)
      max = 0
      (row..(row+rowspan-1)).each do |half_hour|
        # Set the row time boundaries so that an event must extend
        # into the row, not just start or end on the boundary.
        row_time_start = (date + day.days).midnight + half_hour * 30 * 60 + 1
        row_time_end = row_time_start + 30 * 60 - 2
        cols = calc_time_cols(row_time_start, row_time_end, day)
        if cols > max
            max = cols
        end
      end
      max
    end

    # Calculate the number of columns that are required for a
    #  particular row in the table.
    def calc_time_cols(row_time_start, row_time_end, day)
      cols = 0
      if !events[day].nil?
        events[day].each do |event|
          if event.start_time <= row_time_end && 
             event.end_time >= row_time_start
            cols = cols + 1 
          end
        end
      end
       cols
    end

    # Calculate the maximum number of all day events for 
    #  for a day
    def calc_all_day_max
      max = 0
      @events_all_day = []
      (0..(num_days-1)).each do |day|
        count = 0
        day_events = []
        if !events[day].nil?
          events[day].each do |event|
            if event.all_day
              count = count + 1
              day_events << event
            end
          end
        end
        if count > max
          max = count
        end
        @events_all_day << day_events
      end
      max
    end

    # Create hashs which hold the rows that events start and end it,
    #  as well as how many rows they span
    def calc_event_rows
      @events_start = [{},{},{},{},{},{},{}]
      @events_end = [{},{},{},{},{},{},{}]
      @event_span = [{},{},{},{},{},{},{}]
      (0..(num_days-1)).each do |day|
          if !events[day].nil?
            events[day].each do |event|
              if !event.all_day
                if event.start_time < (date + day.days)
                  start_row = 0
                else
                  start_row = (event.start_time.seconds_since_midnight / (60*30)).to_i
                end
                if @events_start[day].member?(start_row)
                  @events_start[day][start_row] << event
                else
                  @events_start[day][start_row] = [event]
                end
                if event.end_time >= (date + (day+1).days)
                  end_row = NUM_HALF_HOURS-1
                else
                  end_row = ((event.end_time.seconds_since_midnight-1) / (60*30)).to_i
                end
                if @events_end[day].member?(end_row)
                  @events_end[day][end_row] << event
                else
                  @events_end[day][end_row] = [event]
                end
                @event_span[day][event] = end_row - start_row + 1
              end
            end
          end
      end
    end

    # Display the all day events in the table
    def all_day_events
      w = (90.0/num_days).to_i
      rows = []
      (1..(@all_day_max)).each do |row|
        cols = []
        c1 = content_tag :td, :width => "8%", :colspan => "2", 
            :class => "day_header"  do
              '' 
        end
        cols << c1
        (0..(num_days-1)).each do |day|
          if @events_all_day[day].size >= row
            event = @events_all_day[day][row-1]
            col = content_tag :td, 
                  :height => "15px",
                  :overflow => "hidden",
                  :style => "width: #{w}%", :width => "#{w}%",
                  :class => "day_appointment " + calb_class(event.calendar, user) do
                content_tag :a, :href => "/events/#{event.id}/edit", 
                  :title => "#{event.title}",
                  :data => {:toggle => "popover", 
                          :content => "#{event.where}#{event.when}#{event.my_notes}",
                          :html => "true",
                          :trigger => "hover",
                          :placement => "left",
                          :remote => true },
                  :class => "event-popover" do
                    content_tag :div, :class => "hide_extra" do
                        self.event_day_text(event,1)
                     end
                end
            end
          else
            col = content_tag :td, 
                  :max => {:height => "15px"},
                  :style => "width: #{w}%", :width => "#{w}%",
                  :class => "day_free_time" do
                ''
            end
          end
          cols << col
        end
        row = content_tag :tr do
          cols.join.html_safe
        end
        rows << row
      end
      rows.join.html_safe
    end

    # Draw the header for the day calendar table
    def header
      columns = []
      content_tag :tr do
        c1 = content_tag :th, :width => "1%", :colspan => "2", 
            :class => "day_header"  do
              'Time' 
        end
        columns << c1
        (0..(num_days-1)).each do |day|
            w = (100.0/num_days).to_i
            c = content_tag :th, :style => "width: #{w}%", :width => "#{w}%", 
                :colspan => @max_cols[day].to_s, :class => "day_header" do
                ''
            end
            columns << c
        end
        columns.join.html_safe
      end
    end

    # Draw the header for the all day events
    def header_all_day
      columns = []
      content_tag :tr do
        c1 = content_tag :th, :width => "8%", :colspan => "2", 
            :class => "day_header"  do
              '' 
        end
        columns << c1
        w = (90.0/num_days).to_i
        this_day = date
        (0..(num_days-1)).each do |day|
            link = url_for :params => params.merge(format: :day, date: this_day)            #link = "#"
            c = content_tag :th, :style => "width: #{w}%", :width => "#{w}%", 
                :colspan => "1", :class => "day_header" do
                content_tag :a, :href => link do
                    this_day.strftime('%b %e')
                end
            end
            columns << c
            this_day = this_day + 1.day
        end
        columns.join.html_safe
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
        cols = []
        row = content_tag :tr do
          cols << hour_cell(half_hour)
          cols << minute_cell(half_hour)
          (0..(num_days-1)).each do |day|
             cols << event_cells(half_hour,day)
          end
          cols.join.html_safe
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
    def event_cells(half_hour, day)
      cols = []
      free_count = 1
      for col in 0..(@max_cols[day]-1) do
        # If the column is empty
        if !@col_event[day].member?(col)
          # See if an event starts in this row and fill it in
          if @events_start[day].member?(half_hour)
            # Remove event start from list
            event = @events_start[day][half_hour].delete_at(0)
            if @events_start[day][half_hour].size == 0
              @events_start[day].delete(half_hour)
            end
            # Find the number of columns it can take
            max = calc_max_cols(half_hour, @event_span[day][event],day) - 1
            if max < 0
                max = 0
            end
            my_cols = @max_cols[day] - max
            for rescol in col..(col+my_cols-1) do
              # Reserve column for event
              @col_event[day][rescol] = event
            end
            # Add event tags
            newcol = content_tag :td, 
                :height => (@event_span[day][event]*15).to_s + "px",
                :class => "day_appointment " + calb_class(event.calendar, user), 
                :colspan => my_cols.to_s, 
                :rowspan => @event_span[day][event].to_s,
                :width =>  (@col_width[day]/my_cols).to_s + '%' do
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
                    self.event_day_text(event, @max_cols[day])
                  end
              end              
            end
            cols << newcol
          # Otherwise it is free time in this column
          else
            # If this is the last column of free time
            if col == @max_cols[day]-1 || @col_event[day].member?(col+1)
              # Add the free time tag
              newcol = content_tag :td, 
                  :class => "day_free_time", 
                  :colspan => free_count.to_s,
                  :width => @col_width[day].to_s + '%' do
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
      if @events_end[day].member?(half_hour)
        @events_end[day][half_hour].each do |event|
          # Find the column the ending event is in
          for col in 0..(@max_cols[day]-1) do
            if @col_event[day].member?(col)
              if @col_event[day][col] == event
                # And remove the event from the column
                @col_event[day].delete(col)
              end
            end
          end
        end
      end
      cols.join.html_safe
    end

    # This method produces text for an event with highlighting to 
    #  be displayed on a single line
    def event_day_text(event, cols)
      if cols == 1
        max_size = 84/num_days
      else
        max_size = 42/(num_days * cols)
      end
      if event.title.size > (max_size)
        text = event.title[0..(max_size - 1)] + '..'
      else
        text = event.title
      end
      text = "<b>" + text + "</b>" 
      text.html_safe
    end

  end
end
