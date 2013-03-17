class SubscriptionsController < ApplicationController
    before_filter :auth_user,   
                only: [:create]

    def new
        # todo change query to remove the ones already subscribed
        @calendars = Calendar.where("public == 't' AND user_id != #{current_user.id}")
        @calendars_by_user = @calendars.group_by { |c| User.where(id: c.user_id)[0].full_name }
        store_referer
    end

    def create
        @subscription = @calendar.subscriptions.build(user_id: params[:user_id])
        @subscription.subscribed = true
        @subscription.rw = false
        @subscription.title = @calendar.title
        @user = User.find(params[:user_id])
        #raise session[:return_to].inspect
        if @subscription.save
            redirect_back_or @user
        else
            flash[:error] = "Error Subscribing to Calendar!"
            redirect_back_or @user
        end
    end

  private
    def auth_user
        @calendar = Calendar.find(params[:calendar_id])
        redirect_to(root_url) unless !@calendar.nil? and @calendar.public?
    end

end
