module SubscriptionsHelper
    def subscription_for_cal_user(calendar_id, user_id)
        #raise calendar_id.inspect
        Subscription.where("user_id = ? AND calendar_id = ?",
                    user_id, calendar_id).first
    end
end
