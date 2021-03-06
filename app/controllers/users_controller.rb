# This class is a rails controller for user objects
# Author::    Mark Grebe  
# Copyright:: Copyright (c) 2013 Mark Grebe
# License::   Distributes under the same terms as Ruby
# Developed for Master of Engineering Project
# University of Colorado - Boulder - Spring 2013
class UsersController < ApplicationController
    before_filter :signed_in_user, 
                only: [:edit, :show, :update]
    before_filter :correct_user,   
                only: [:edit, :show, :update]
    before_filter :admin_user, only: [:index, :destroy]

    # List users for admin access
    def index
        @users = User.paginate(page: params[:page])
    end

    def new
        @user = User.new
    end

    # Display a users calendars in the proper view
    def show
        @user = User.find(params[:id])
        @calendar = Calendar.new
        @subscription = Subscription.new
        @default_calendar = Calendar.where(default: true, user_id: @user.id)[0]
        @calendars = @user.calendars 
        list_all_calendars
        @subscribed_calendars = get_subscribed_calendars
        @date = params[:date] ? Date.parse(params[:date]) : Time.zone.now.to_date
        @event = @default_calendar.events.build
        if (params[:format].nil?)
            @format = @user.default_view.to_sym
        else
            @format = params[:format].to_sym
        end 
        # Handle the day view  
        if @format == :day
            @events = [events_for_date(@date)]
        # Handle the week view
        elsif @format == :week
            start_date = @date.beginning_of_week(:sunday)
            @events = []
            (0..6).each do |d|
                @events << events_for_date(start_date + d.days)
            end
        # Handle the month view
        elsif @format == :month
            first = @date.beginning_of_month.beginning_of_week(:sunday)
            last = @date.end_of_month.end_of_week(:sunday)
            day = first
            @events_by_date = {}
            while day <= last
                @events_by_date[day] = events_for_date(day)
                day = day + 1.day
            end 
        # Handle the list view
        else
            @events = events_for_current_user.sort { |a,b| a.start_time <=> b.start_time }
        end 
    end

    # Create a new user
    def create
        @user = User.new(params[:user])
        if @user.save
            # Create the default calendar for the user
            cal = @user.calendars.build(default: true)
            cal.save
            sign_in @user
            flash[:success] = "Welcome to Calendaring, " + @user.full_name + "!"
            redirect_to @user
        else
            redirect_to request.referer
        end
    end

    def edit
    end

    def update
        # Settings Update (non-password)
        if params[:user][:password] == nil
            params[:user].each do |name, value|
                if name == 'default_view'
                    value = value.to_sym
                end
                @user.update_attribute(name, value)
            end
            flash[:success] = "Settings updated"
            redirect_to @user
        # Password Update
        else
            # Validate the user, or allow an admin to change a users
            # password without specifying the old one.  (Except for theirs
            # or another admin user)
            if (current_user.admin? and !current_user?(@user) and !@user.admin?) or
                 @user.authenticate(params[:user][:old_password])
                params[:user].delete(:old_password)
                if @user.update_attributes(params[:user])
                    if !(current_user.admin? and !current_user?(@user))
                        flash[:success] = "Password updated"
                        sign_in @user
                        redirect_to @user
                    else
                        flash[:success] = "User Password updated"
                        redirect_to current_user
                    end
                else
                    render 'edit'
                end
            else
                flash[:error] = "Incorrect current password"
                render 'edit'
            end
        end
    end

    # AJAX routine to check the username, making sure it does not exist already
    def check
        users = User.where(username: params[:user][:username])
        response = users.size == 0
        respond_to do |format|
            format.json { render :json => response }
        end
    end

    # AJAX routine to verify the username, making sure it does exist 
    def verify
        users = User.where(username: params[:subscription][:username])
        response = (users.size != 0)
        respond_to do |format|
            format.json { render :json => response }
        end
    end

    # AJAX routine to user for Typeahead finding of usernames
    def search
        users = User.where("username LIKE :prefix", prefix: "#{params[:q]}%")
        usernames = []
        users.each do |user|
            usernames << user.username
        end
        respond_to do |format|
            format.json { render :json => usernames }
        end
    end

    # Destroy a user
    def destroy
        User.find(params[:id]).destroy
        flash[:success] = "User destroyed."
        redirect_to users_url
    end

  private
    # Determine if a current user can display this users's pages
    def correct_user
      @user = User.find(params[:id])
      if params[:action] == "show"
          redirect_to(root_url) unless current_user?(@user)
      else
          redirect_to(root_url) unless current_user?(@user) or current_user.admin?
      end
    end

    # Determine if current user is an admin user
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    # Retrieve the events for a date for day, week, or month views
    def events_for_date(event_date)
        events = []
        cals = @user.calendars
        cals.each do |cal|
            if cal.displayed.nil? or cal.displayed
                events = events + cal.events.where("start_time <= :end_of_day AND end_time >= :start_of_day ",
                    {:end_of_day => event_date.end_of_day, 
                     :start_of_day => event_date.beginning_of_day})
            end
        end
        cals = get_subscribed_calendars
        cals.each do |cal|
            sub = Subscription.where(calendar_id: cal.id, user_id: @user.id).first
            if sub.displayed?
                events = events + cal.events.where("start_time <= :end_of_day AND end_time >= :start_of_day ",
                    {:end_of_day => event_date.end_of_day, 
                     :start_of_day => event_date.beginning_of_day})
            end
        end
        events.sort! { |a,b| a.start_time <=> b.start_time }
    end

    # Retrieve all events for a user in lists form
    def events_for_current_user
        events = []
        cals = @user.calendars 
        cals.each do |cal|
            if cal.displayed.nil? or cal.displayed
                events = events + cal.events
            end
        end
        cals = get_subscribed_calendars
        cals.each do |cal|
            sub = Subscription.where(calendar_id: cal.id, user_id: @user.id).first
            if sub.displayed?
                events = events + cal.events
            end
        end
        events
    end

    # Retrieve an array of all calendars user is subscribed to
    def get_subscribed_calendars
        cals = []
        @user.subscriptions.each do |sub|
            if sub.subscribed?
                cals << Calendar.find(sub.calendar_id)
            end
        end
        cals
    end

    # Create an array of all calendars user is subscribed to for
    # use in dropdown menu.  Also create a list of those calendars
    # that are readonly, so that they may be disabled from selection.
    def list_all_calendars 
        @all_calendars = []
        @readonly_calendars = []
        @calendars.each do |calendar|
            @all_calendars << [calendar.title, calendar.id]
        end
        @user.subscriptions.each do |sub|
            if sub.subscribed?
                @all_calendars << [sub.title, sub.calendar.id]
                if !sub.rw?
                    @readonly_calendars << sub.title
                end
            end
        end
    end
end
