# This module is a rails helper for setting display colors
# for calendars.
# Author::    Mark Grebe  
# Copyright:: Copyright (c) 2013 Mark Grebe
# License::   Distributes under the same terms as Ruby
# Developed for Master of Engineering Project
# University of Colorado - Boulder - Spring 2013
CALF_CLASS = Hash.new("calf_blue")
CALF_CLASS[0] = "calf_blue"
CALF_CLASS[1] = "calf_red"
CALF_CLASS[2] = "calf_orange"
CALF_CLASS[3] = "calf_yellow"
CALF_CLASS[4] = "calf_green"
CALF_CLASS[5] = "calf_purple"
CALF_CLASS[6] = "calf_brown"

CALB_CLASS = Hash.new("calb_blue")
CALB_CLASS[0] = "calb_blue"
CALB_CLASS[1] = "calb_red"
CALB_CLASS[2] = "calb_orange"
CALB_CLASS[3] = "calb_yellow"
CALB_CLASS[4] = "calb_green"
CALB_CLASS[5] = "calb_purple"
CALB_CLASS[6] = "calb_brown"

module CalendarsHelper
    def calf_class(calendar, user)
        if calendar.user_id == user.id
            if calendar.color.nil?
                return CALF_CLASS[0]
            else
                return CALF_CLASS[calendar.color.value]
            end
        else
            sub = Subscription.where("user_id = ? AND calendar_id = ?",
                    user.id, calendar.id)
            return CALF_CLASS[sub.first.color.value]
        end
    end

    def calb_class(calendar, user)
        if calendar.user_id == user.id
            if calendar.color.nil?
                return CALB_CLASS[0]
            else
                return CALB_CLASS[calendar.color.value]
            end
        else
            sub = Subscription.where("user_id = ? AND calendar_id = ?",
                    user.id, calendar.id)
            return CALB_CLASS[sub.first.color.value]
        end
    end

end


