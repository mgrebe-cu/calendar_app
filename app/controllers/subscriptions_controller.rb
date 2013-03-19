class SubscriptionsController < ApplicationController
    before_filter :auth_user,   
                only: [:create]

    def new
        # Query to find pulic candards other than those owned by curent user
        pub_cal = "public == 't' AND user_id != #{current_user.id}"
        @calendars = Calendar.where("public == 't' AND user_id != ?",
                      current_user.id)
        # Remove any from the list the user is already subscribed to
        @calendars.reject! do |c|
            Subscription.where("user_id == ? AND calendar_id == ?",
                current_user.id, c.id).size != 0
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

  def show
    @subscription = Subscription.find_by_id(params[:id])
    @subscription.displayed = params[:displayed]
    if @subscription.save
        redirect_to request.referer
    else
        flash[:error] = "Error showing/hiding subscription!"  
        redirect_to request.referer
    end
  end

  def edit
    @subscription = Subscription.find_by_id(params[:id])
    respond_to do |format|
        format.html
        format.js 
    end
  end

  def update
    @subscription = Subscription.find_by_id(params[:id])
    if @subscription.update_attributes(params[:subscription])
      redirect_to request.referer
    else
      flash[:error] = "Subscription update failed!"  
      redirect_to request.referer
    end
  end
 
  def destroy
    @subscription = Subscription.find_by_id(params[:id])
    @subscription.destroy
    redirect_to request.referer
  end

  def check
    id = params[:subcheck].split('/').last.to_i
    sub = Subscription.where(id: id)
    if sub.size != 0 and sub[0].title == params[:subscription][:title]
      response = true
    else
      cals = Calendar.where(user_id: current_user.id, title: params[:subscription][:title])
      subs = Subscription.where(user_id: current_user.id, title: params[:subscription][:title])
      response = (cals.size == 0 and subs.size == 0)
    end
    respond_to do |format|
      format.json { render :json => response }
    end
  end

  private
    def auth_user
        @calendar = Calendar.find(params[:calendar_id])
        redirect_to(root_url) unless !@calendar.nil? and @calendar.public?
    end

end
