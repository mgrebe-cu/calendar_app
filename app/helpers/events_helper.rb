module EventsHelper
    def current_user_has_rw?(event)
        cal = Calendar.find_by_id(event.calendar_id)
        current_user.id == cal.user_id
    end
end
