# This module is a rails helper for events
# Author::    Mark Grebe  
# Copyright:: Copyright (c) 2013 Mark Grebe
# License::   Distributes under the same terms as Ruby
# Developed for Master of Engineering Project
# University of Colorado - Boulder - Spring 2013
module EventsHelper
    # Determine if the current user is able to modify an event
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
