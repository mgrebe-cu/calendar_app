class SubscriptionsController < ApplicationController
    before_filter :auth_user,   
                only: [:create]

    def new
        # todo change query to remove the ones already subscribed
        @calendars = Calendar.where("public == 't' AND user_id != #{current_user.id}")
        @calendars_by_user = @calendars.group_by { |c| User.where(id: c.user_id)[0].full_name }
    end

    def create
        @subscription = @calendar.subscriptions.build(user_id: params[:user_id])
        @subscription.subscribed = true
        @subscription.rw = false
        @subscription.title = @calendar.title
        if @subscription.save
            redirect_to request.referer
        else
            flash[:error] = "Error Subscribing to Calendar!"
            redirect_to request.referer
        end
    end

  private
    def auth_user
        @calendar = Calendar.find(params[:calendar_id])
        redirect_to(root_url) unless !@calendar.nil? and @calendar.public?
    end

end
