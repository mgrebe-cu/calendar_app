class SubscriptionsController < ApplicationController
    before_filter :signed_in_user
    before_filter :auth_user,   
                only: [:create]
    before_filter :sub_user, only: [:show, :edit]
    before_filter :update_user, only: [:update]
    before_filter :destroy_user, only: [:destroy]

  def new
    # Query to find pulic calendards other than those owned by curent user
    @calendars = Calendar.where("public == 't' AND user_id != ?",
                  current_user.id)
    # Remove any from the list the user is already subscribed to
    @calendars.reject! do |c|
        Subscription.where("user_id == ? AND calendar_id == ?",
          current_user.id, c.id).size != 0
    end
    # Calendars that have specific access given to this user
    subs = Subscription.where("user_id == ? AND subscribed == 'f'",
          current_user.id);
    subs.each do |sub|
      @calendars << Calendar.find_by_id(sub.calendar_id)
    end
    @calendars_by_user = 
      @calendars.group_by { |c| User.where(id: c.user_id)[0].username }
    store_referer
  end

  def create
    if request.xhr?
      create_share
    else
      create_subscription
    end
  end

  def show
    @subscription.displayed = params[:displayed]
    if @subscription.save
      redirect_to request.referer
    else
      flash[:error] = "Error showing/hiding subscription!"  
      redirect_to request.referer
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js 
    end
  end

  def update
    if request.xhr?
      @subscription.rw = !@subscription.rw
      if !@subscription.save
        flash[:error] = "Subscription update failed!"  
        redirect_to request.referer
      end
      @calendar = Calendar.find_by_id(@subscription.calendar_id)
    else
      if @subscription.update_attributes(params[:subscription])
        redirect_to request.referer
      else
        flash[:error] = "Subscription update failed!"  
        redirect_to request.referer
      end
    end
  end
 
  def destroy
    @calendar = Calendar.find_by_id(@subscription.calendar_id)
    if @calendar.public? or request.xhr?
      @subscription.destroy
    else
      @subscription.subscribed = false
      @subscription.save
    end
    if !request.xhr?
      redirect_to request.referer
    end
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
      if @calendar.nil?
        redirect_to(root_url)
      else
        if !@calendar.public?
          if Subscription.where("user_id == ? AND calendar_id == ?",
              current_user.id, @calendar.id).size == 0
            if current_user.id != @calendar.user_id
              redirect_to(root_url)
            end
          end
        end
      end
    end

    def sub_user
      @subscription = Subscription.find_by_id(params[:id])
      redirect_to(root_url) if @subscription.user_id != current_user.id
    end

    def update_user
      @subscription = Subscription.find_by_id(params[:id])
      if request.xhr?
        if Calendar.find_by_id(@subscription.calendar_id).user_id != current_user.id
          redirect_to(root_url)
        end
      else
        redirect_to(root_url) if @subscription.user_id != current_user.id
      end
    end

    def destroy_user
      @subscription = Subscription.find_by_id(params[:id])
      if current_user.id != @subscription.user_id and
         current_user.id != Calendar.find_by_id(@subscription.calendar_id).user_id
          redirect_to(root_url)
      end
    end

    def unique_title
      share_num = 1
      while true
        title = "Share" + share_num.to_s
        cals = Calendar.where(user_id: current_user.id, title: title)
        subs = Subscription.where(user_id: current_user.id, title: title)
        if cals.size == 0 and subs.size == 0
          break
        end
        share_num = share_num + 1
      end
      title
    end

    def create_subscription
      @subscription = @calendar.subscriptions.find_by_user_id(current_user.id)
      if @subscription.nil?
        @subscription = @calendar.subscriptions.build(user_id: current_user.id)
        @subscription.rw = false
      end
      @subscription.subscribed = true
      @subscription.title = unique_title
      if @subscription.save
        redirect_back_or current_user
      else
        flash[:error] = "Error Subscribing to Calendar!"
        redirect_back_or @current_user
      end
    end

    def create_share
      @user = User.where(username: params[:subscription][:username]).first
      if @user.nil?
        #to do error message
      else
        @subscription = @calendar.subscriptions.build(user_id: @user.id)
        if !params[:subscription][:rw].nil?
          @subscription.rw = params[:subscription][:rw]
        else
          @subscription.rw = false
        end
        @subscription.title = unique_title
        @subscription.save
      render :partial => "subscriptions/create"
      end
    end
end
