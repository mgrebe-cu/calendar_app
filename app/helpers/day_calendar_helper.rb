# 
module DayCalendarHelper
  def day_calendar(date = Date.today, events)
    DayCalendar.new(self, date, events).table
  end

  class DayCalendar < Struct.new(:view, :date, :events)
    delegate :content_tag, to: :view

    NUM_QUARTER_HOURS = 24*4

    def table
      @max_cols = calc_max_cols(0, NUM_QUARTER_HOURS)
      @max_cols = 1 if @max_cols ==0
      @col_width = (100.0/@max_cols + 0.5).to_i
      calc_event_rows
      @col_event = {}
      content_tag :div do
        all_day_table + hour_table
      end
    end
 
    def hour_table
      content_tag :div, :class => "day_div" do
        content_tag :table do
          header + time_body
        end
      end
    end
 
    def all_day_table
      content_tag :table, :width => "100%" do
        header_all_day + all_day_events
      end
    end
 
    def calc_max_cols(row, rowspan)
      max = 0
      (row..(row+rowspan-1)).each do |qh|
        # Set the row time boundaries so that an event must extend
        # into the row, not just start or end on the boundary.
        row_time_start = date.midnight + qh * 15 * 60 + 1
        row_time_end = row_time_start + 15 * 60 - 2
        cols = calc_time_cols(row_time_start, row_time_end)
        if cols > max
          max = cols
        end
      end
      max
    end

    def calc_time_cols(row_time_start, row_time_end)
      cols = 0
      if !events.nil?
        events.each do |event|
          if event.start <= row_time_end && event.end >= row_time_start
            cols = cols + 1 
          end
        end
      end
      cols
    end

    def calc_event_rows
      @events_start = {}
      @events_end = {}
      @event_span = {}
      if !events.nil?
        events.each do |event|
          if !event.all_day
            start_row = (event.start.seconds_since_midnight / (60*15)).to_i
            if @events_start.member?(start_row)
              @events_start[start_row] << event
            else
              @events_start[start_row] = [event]
            end
            end_row = ((event.end.seconds_since_midnight-1) / (60*15)).to_i
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

    def all_day_events
      rows = []
      if !events.nil?
        events.each do |event|
          if event.all_day
            row = content_tag :tr do
              content_tag :td, :colspan => "2", 
                  :title => "#{event.title}",
                  :max => {:height => "15px"},
                  :data => {:toggle => "popover", 
                          :content => "#{event.where}#{event.when}#{event.my_notes}",
                          :true => "true",
                          :trigger => "hover",
                          :placement => "top"},
                  :class => "day_all_event event-popover" do
                content_tag :a, :href => "/events/#{event.id}/edit", 
                  :data => {:remote => true} do
                    event.title + '  ' + event.where
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

    def header_all_day
      content_tag :tr do
        content_tag :th, :width => "100%", 
            :class => "day_header" do
          'All Day Events'
        end
      end
    end

    def time_body
      content_tag :tbody do
        time_rows
      end
    end

    def time_rows
      rows = []
      (0..NUM_QUARTER_HOURS-1).each do |qh|
        row = content_tag :tr do
          [hour_cell(qh), minute_cell(qh), event_cells(qh)].join.html_safe
        end
        rows << row
      end
      rows.join.html_safe
    end

    def hour_cell(qh)
      if qh % 4 == 0
        content_tag :td, :class => "day_hour_cell", 
              :width => "1%", :rowspan => 4 do
          if (qh/4 == 0)
            ''
          elsif (qh/4 < 12)
            (qh/4).to_s + 'am'
          elsif (qh/4 == 12)
            'Noon'
          elsif (qh/4 > 12)
            ((qh/4) - 12).to_s + 'pm'
          end
        end
      else
        nil
      end
    end

    def minute_cell(qh)
      content_tag :td, :class => "day_min_cell" do
        if (qh%4 == 0)
          '00'
        else
          ((qh%4)*15).to_s
        end
      end
    end

    def event_cells(qh)
      cols = []
      free_count = 1
      for col in 0..(@max_cols-1) do
        # If the column is empty
        if !@col_event.member?(col)
          # See if an event starts in this row and fill it in
          if @events_start.member?(qh)
            # Remove event start from list
            event = @events_start[qh].delete_at(0)
            if @events_start[qh].size == 0
              @events_start.delete(qh)
            end
            # Find the number of columns it can take
            max = calc_max_cols(qh, @event_span[event]) - 1
            my_cols = @max_cols - max
            for rescol in col..(col+my_cols-1) do
              # Reserve column for event
              @col_event[rescol] = event
            end
            # Add event tags
            newcol = content_tag :td, 
                :title => "#{event.title}",
                :max => {:height => @event_span[event].to_s + 'px'},
                :data => {:toggle => "popover", 
                          :content => "#{event.where}#{event.when}#{event.my_notes}",
                          :true => "true",
                          :trigger => "hover",
                          :placement => "top"},
                :class => "day_appointment event-popover", 
                :colspan => my_cols.to_s, 
                :rowspan => @event_span[event].to_s,
                :width =>  @col_width.to_s + '%' do
              c1 = content_tag :div, event.title
              c2 = content_tag :div, event.where
              c3 = content_tag :div, event.when
              content_tag :a, :href => "/events/#{event.id}/edit", 
                :data => {:remote => true} do
                  c1+c2+c3
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
      if @events_end.member?(qh)
        @events_end[qh].each do |event|
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

  end
end
