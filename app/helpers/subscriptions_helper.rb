# This module is a rails helper for subscriptions
# Author::    Mark Grebe  
# Copyright:: Copyright (c) 2013 Mark Grebe
# License::   Distributes under the same terms as Ruby
# Developed for Master of Engineering Project
# University of Colorado - Boulder - Spring 2013
module SubscriptionsHelper
    def subscription_for_cal_user(calendar_id, user_id)
        Subscription.where("user_id = ? AND calendar_id = ?",
                    user_id, calendar_id).first
    end
end
