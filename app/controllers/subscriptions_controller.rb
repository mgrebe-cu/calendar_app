class SubscriptionsController < ApplicationController
    before_filter :auth_user,   
                only: [:create]

    def new
        # Query to find pulic candards other than those owned by curent user
        pub_cal = "public == 't' AND user_id != #{current_user.id}"
        @calendars = Calendar.where(pub_cal)
        # Remove any from the list the user is already subscribed to
        @calendars.reject! do |c|
            already_sub = "user_id == #{current_user.id} AND calendar_id == #{c.id}"
            Subscription.where(already_sub).size != 0
        end
        @calendars_by_user = 
            @calendars.group_by { |c| User.where(id: c.user_id)[0].full_name }
        store_referer
    end

    def create
        @subscription = @calendar.subscriptions.build(user_id: params[:user_id])
        @subscription.subscribed = true
        @subscription.rw = false
        @subscription.title = @calendar.title
        @user = User.find(params[:user_id])
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
