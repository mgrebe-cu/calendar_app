class UsersController < ApplicationController
    before_filter :signed_in_user, 
                only: [:edit, :show, :update]
    before_filter :correct_user,   
                only: [:edit, :show, :update]
    before_filter :admin_user, only: [:index, :destroy]

    def index
        @users = User.paginate(page: params[:page])
    end

    def new
        @user = User.new
    end

    def show
        @user = User.find(params[:id])
        @calendar = Calendar.new
        @default_calendar = Calendar.where(default: true, user_id: @user.id)[0]
        @calendars = Calendar.where(user_id: @user.id)
        @date = params[:date] ? Date.parse(params[:date]) : Time.zone.now.to_date
        @event = @default_calendar.events.build
        if (params[:format].nil?)
            @format = @user.default_view.to_sym
        else
            @format = params[:format].to_sym
        end   
        if @format == :day
            @events = [events_for_date(@date)]
        elsif @format == :week
            start_date = @date.beginning_of_week(:sunday)
            @events = []
            (0..6).each do |d|
                @events << events_for_date(start_date + d.days)
            end
        elsif @format == :month
            first = @date.beginning_of_month.beginning_of_week(:sunday)
            last = @date.end_of_month.end_of_week(:sunday)
            day = first
            @events_by_date = {}
            while day <= last
                @events_by_date[day] = events_for_date(day)
                day = day + 1.day
            end 
        else
            @events = events_for_current_user.sort { |a,b| a.start_time <=> b.start_time }
        end 
    end

    def create
        @user = User.new(params[:user])
        if @user.save
            cal = @user.calendars.build(default: true)
            cal.save
            sign_in @user
            flash[:success] = "Welcome to Calendaring, " + @user.full_name + "!"
            redirect_to request.referer
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
            if @user.update_attributes(params[:user])
                flash[:success] = "Settings updated"
                sign_in @user
                redirect_to @user
            else
                render 'edit'
            end
        end
    end

    def check
        users = User.where(username: params[:user][:username])
        response = users.size == 0
        respond_to do |format|
            format.json { render :json => response }
        end
    end

    def destroy
        User.find(params[:id]).destroy
        flash[:success] = "User destroyed."
        redirect_to users_url
    end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def events_for_date(event_date)
        events = []
        cals = current_user.calendars
        cals.each do |cal|
            if cal.displayed.nil? or cal.displayed
                events = events + cal.events.where("start_time <= :end_of_day AND end_time >= :start_of_day ",
                    {:end_of_day => event_date.end_of_day, 
                     :start_of_day => event_date.beginning_of_day})
            end
        end
        events.sort! { |a,b| a.start_time <=> b.start_time }
    end

    def events_for_current_user
        events = []
        cals = current_user.calendars
        cals.each do |cal|
            if cal.displayed.nil? or cal.displayed
                events = events + cal.events
            end
        end
        events
    end
end
