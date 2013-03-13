class CalendarsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, only: [:edit, :show, :update]
  
  def new
    @calendar = Calendar.new
  end

  def create
    @calendar = Calendar.new(params[:calendar])
    @calendar.user_id = current_user.id
    @calendar.default = false
    if @calendar.save
        flash[:success] = "Calendar Created Succssfully!"
        redirect_to current_user
    else
        raise @calendar.inspect
        render 'new'
    end
  end

  def edit
    @calendar = Calendar.find_by_id(params[:id])
  end

  def update
    @calendar = Calendar.find_by_id(params[:id])

  end

  private

    def correct_user
      @calendar = current_user.calendars.find_by_id(params[:id])
      redirect_to root_url if @calendar.nil?
    end

end
