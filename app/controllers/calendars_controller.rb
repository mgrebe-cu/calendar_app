# This class is a rails controller for calendar objects
# Author::    Mark Grebe  
# Copyright:: Copyright (c) 2013 Mark Grebe
# License::   Distributes under the same terms as Ruby
# Developed for Master of Engineering Project
# University of Colorado - Boulder - Spring 2013
class CalendarsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, only: [:edit, :show, :update]
  
  # Start creating a new calendar
  def new
    @calendar = Calendar.new
    @calendar.title = ""
  end

  # Save a new calendar
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

  # Setup to edit a calendar
  def edit
    @calendar = Calendar.find_by_id(params[:id])
    respond_to do |format|
        format.html
        format.js 
    end
  end

  # Handle user clicking to show or not show a calendar
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

  # Update an edited calendar
  def update
    @calendar = Calendar.find_by_id(params[:id])
    if @calendar.update_attributes(params[:calendar])
      redirect_to request.referer
    else
      flash[:error] = "Calendar update failed!"  
      redirect_to request.referer
    end
  end
 
  # Delete a calendar
  def destroy
    @calendar = Calendar.find_by_id(params[:id])
    @calendar.destroy
    redirect_to request.referer
  end

  # Utility AJAX method used to determine if calendar title is unique
  def check
    id = params[:calcheck].split('/').last.to_i
    cal = Calendar.where(id: id)
    # For invalid calendars or unchanged titles, just return valid
    if cal.size != 0 and cal[0].title == params[:calendar][:title]
      response = true
    else
      # Check both local and shared calendar names
      cals = Calendar.where(user_id: current_user.id, title: params[:calendar][:title])
      subs = Subscription.where(user_id: current_user.id, title: params[:calendar][:title])
      response = (cals.size == 0 and subs.size == 0)
    end
    respond_to do |format|
      format.json { render :json => response }
    end
  end

  private

    # Valaidte the user, making sure they own the calendar being accessed
    def correct_user
      @calendar = current_user.calendars.find_by_id(params[:id])
      redirect_to root_url if @calendar.nil?
    end

end
