# Based on code by Ryan Bates from railscasts.com
module DayCalendarHelper
  def day_calendar(date = Date.today, events)
    DayCalendar.new(self, date, events).table
  end

  class DayCalendar < Struct.new(:view, :date, :events)
    delegate :content_tag, to: :view

    NUM_QUARTER_HOURS = 24*4

    def table
      calc_max_cols
      @col_event = {}
      content_tag :div, :class => "day_cal_div" do
        content_tag :table do
          header + time_body
        end
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

    def start_in_row?(event, row_time)
      event.start >= row_time && event.start <= (row_time + 15*60)
    end

    def end_in_row?(event, row_time)
      event.end >= row_time && event.start <= (row_time + 15*60)
    end

    def header
      content_tag :tr do
        header_time + header_event
      end
    end

    def header_time
      content_tag :th, :width => "1%", :colspan => "2", 
          :class => "day_cal_header"  do
            'Time' 
      end
    end

    def header_event
      content_tag :th, :style => "width: 100%", :width => "100%", 
            :colspan => @max_cols.to_s, :class => "day_cal_header" do
        ''
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
      content_tag :td, :class => "day_cal_free_time", 
        :colspan => @max_cols.to_s do
          ''
      end
    end
  end
end
