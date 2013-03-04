module EventsHelper
    def date_format_for_form(date_string)
        [date_string[5..6],'/',date_string[8..9],'/',date_string[0..3]].join
    end
end
