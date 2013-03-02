class UsersController < ApplicationController
    before_filter :signed_in_user, 
                only: [:edit, :show, :update]
    before_filter :correct_user,   
                only: [:edit, :show, :update]

    def new
        @user = User.new
    end

    def show
        #todo This needs to be refactored should only get events for 
        #     required days.
        @user = User.find(params[:id])
        @calendar = Calendar.where(default: true, user_id: @user.id)[0]
        @date = params[:date] ? Date.parse(params[:date]) : Date.today
        @event = @calendar.events.build
        if (params[:format].nil?)
            @format = @user.default_view.to_sym
        else
            @format = params[:format].to_sym
        end   
        @events = @user.get_events.sort! { |a,b| a.start <=> b.start }
        @events.sort! { |a,b| a.start <=> b.start }
        @events_by_date = @events.group_by(&:start_date)
        if @format == :day
            @events = @events_by_date[@date]
        end 
    end

    def create
        @user = User.new(params[:user])
        if @user.save
            cal = @user.calendars.build(default: true)
            cal.save
            sign_in @user
            flash[:success] = "Welcome to Calendaring, " + @user.full_name + "!"
            redirect_to @user
        else
            render 'new'
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

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

end
