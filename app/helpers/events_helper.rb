module EventsHelper
    def current_user_has_rw?(event)
        sub = Subscription.find_by_calendar_id(event.calendar_id)
        if !sub.nil?
            sub.rw 
        else
            cal = Calendar.find_by_id(event.calendar_id)
            current_user.id == cal.user_id
        end
    end
end
