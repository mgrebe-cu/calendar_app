class CalendarsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, only: [:edit, :show, :update]
  
  def new
    @calendar = Calendar.new
    @calendar.title = ""
  end

  def create
    @calendar = Calendar.new(params[:calendar])
    @calendar.user_id = current_user.id
    @calendar.default = false
    if @calendar.save
        redirect_to request.referer
    else
        flash[:error] = "Duplicate Calendar Title Not Allowed!"  
        redirect_to request.referer
    end
  end

  def edit
    @calendar = Calendar.find_by_id(params[:id])
    respond_to do |format|
        format.html
        format.js 
    end
  end

  def show
    @calendar = Calendar.find_by_id(params[:id])
    @calendar.displayed = params[:displayed]
    if @calendar.save
        redirect_to request.referer
    else
        flash[:error] = "Error showing/hiding calendar!"  
        redirect_to request.referer
    end
  end

  def update
    @calendar = Calendar.find_by_id(params[:id])
    if @calendar.update_attributes(params[:calendar])
      redirect_to request.referer
    else
      flash[:error] = "Calendar update failed!"  
      redirect_to request.referer
    end
  end
 
  def destroy
    @calendar = Calendar.find_by_id(params[:id])
    @calendar.destroy
    redirect_to request.referer
  end

  private

    def correct_user
      @calendar = current_user.calendars.find_by_id(params[:id])
      redirect_to root_url if @calendar.nil?
    end

end
