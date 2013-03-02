# 
module DayCalendarHelper
  def day_calendar(date = Date.today, events)
    DayCalendar.new(self, date, events).table
  end

  class DayCalendar < Struct.new(:view, :date, :events)
    delegate :content_tag, to: :view

    NUM_QUARTER_HOURS = 24*4

    def table
      calc_max_cols
      calc_event_rows
      @col_event = {}
      content_tag :div do
        all_day_table + hour_table
      end
    end
 
    def hour_table
      content_tag :div, :class => "day_cal_div" do
        content_tag :table do
          header + time_body
        end
      end
    end
 
    def all_day_table
      content_tag :table do
        header_all_day + all_day_events
      end
    end
 
    def calc_max_cols
      @max_cols = 1
      (0..NUM_QUARTER_HOURS-1).each do |qh|
        row_time = date.midnight + qh * 15 * 60
        cols = calc_time_cols(row_time)
        if cols > @max_cols
          @max_cols = cols
        end
      end
      @col_width = (100.0/@max_cols + 0.5).to_i
    end

    def calc_time_cols(row_time)
      cols = 0
      if !events.nil?
        events.each do |event|
          if event.start <= row_time && event.end >= row_time
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

    def all_day_events
      rows = []
      events.each do |event|
        if event.all_day
          row = content_tag :tr do
            content_tag :td, :class => "day_cal_free_time" do
              event.title
            end
          end
          rows << row
        end
      end
      rows.join.html_safe
    end

    def header
      content_tag :tr do
        c1 = content_tag :th, :width => "1%", :colspan => "2", 
            :class => "day_cal_header"  do
              'Time' 
        end
        c2 = content_tag :th, :style => "width: 100%", :width => "100%", 
            :colspan => @max_cols.to_s, :class => "day_cal_header" do
              ''
        end
        c1 + c2
      end
    end

    def header_all_day
      content_tag :tr do
        content_tag :th, :style => "width: 100%", :width => "100%", 
            :class => "day_cal_header" do
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
        rows << time_row(qh)
      end
      rows.join.html_safe
    end

    def time_row(qh)
      content_tag :tr do
        [hour_cell(qh), minute_cell(qh), event_cells(qh)].join.html_safe
      end
    end

    def hour_cell(qh)
      if qh % 4 == 0
        content_tag :td, :class => "day_cal_hour_cell", 
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
      content_tag :td, :class => "day_cal_min_cell" do
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
          if @events_start.member?(qh) && @events_start[qh].size != 0
            event = @events_start[qh].delete_at(0)
            if @events_start[qh].size == 0
              @events_start.delete(qh)
            end
            @col_event[col] = event
            newcol = content_tag :td, 
                :class => "day_cal_appointment", 
                :colspan => "1", 
                :rowspan => @event_span[event].to_s,
                :width =>  @col_width.to_s + '%' do
              event.title
            end
            free_count = 1
            cols << newcol
          # Otherwise it is free time in this column
          else
            if col == @max_cols-1 || @col_event.member?(col+1)
              newcol = content_tag :td, 
                  :class => "day_cal_free_time", 
                  :colspan => free_count.to_s,
                  :width => (@col_width).to_s + '%' do
                ''
              end
            else
              free_count = free_count + 1
            end
            cols << newcol
          end
        else
          # See if the event ends in this row
          if @events_end.member?(qh) && @events_end[qh].size != 0
            @col_event.delete(col)
          end
        end
      end
      cols.join.html_safe
    end

  end
end
