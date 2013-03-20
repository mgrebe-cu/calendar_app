module EventsHelper
    def current_user_has_rw?(event)
        #current_user.id == cal.user_id
        sub = Subscription.find_by_calendar_id(event.calendar_id)
        if !sub.nil?
            sub.rw 
        else
            false
        end
    end
end
