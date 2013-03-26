# This class is a rails controller for event objects
# Author::    Mark Grebe  
# Copyright:: Copyright (c) 2013 Mark Grebe
# License::   Distributes under the same terms as Ruby
# Developed for Master of Engineering Project
# University of Colorado - Boulder - Spring 2013
class EventsController < ApplicationController
    before_filter :signed_in_user
    before_filter :correct_user,   only: [:update, :destroy]

    # This utility method converts the time and date fields from the event form
    # into the start and end times.
    def parse_params
        # Find the offset so we store times in UTC
        offset = Time.zone.now.time_zone.utc_offset
        # Make sure and check if our timezone currently has daylight savings time
        if Time.zone.now.dst?
            offset = offset + 60*60
        end
        begin
            if @event.all_day
                start_t = params[:event][:start_date]
                @event.start_time = DateTime.strptime(start_t, "%m/%d/%Y")
                @event.start_time = @event.start_time + 12*60*60
            else
                start_t = params[:event][:start_date] + ' ' + params[:event][:start_time]
                @event.start_time = DateTime.strptime(start_t, "%m/%d/%Y %H:%M %p")
                @event.start_time = @event.start_time - offset
            end
        rescue
            @event.start_time = nil
        end
        begin
            if @event.all_day
                end_t = params[:event][:end_date]
                @event.end_time = DateTime.strptime(end_t, "%m/%d/%Y")
                @event.end_time = @event.end_time + 12*60*60
            else
                end_t = params[:event][:end_date] + ' ' + params[:event][:end_time]
                @event.end_time = DateTime.strptime(end_t, "%m/%d/%Y %H:%M %p")
                @event.end_time = @event.end_time - offset
            end
        rescue
            @event.end_time = nil
        end
        begin 
            @event.start_date = @event.start_time.to_date
        rescue
            @event.start_date = nil
        end
        begin 
            @event.end_date = @event.end_time.to_date
        rescue
            @event.end_date = nil
        end
        @event.calendar_id = params[:event][:calendar_id]
    end

    # Create a new event
    def create
        calendar = Calendar.where(default: true, user_id: current_user.id)[0]
        @event = calendar.events.build(params[:event])

        parse_params
        if @event.save
            redirect_to request.referer
        else
            flash[:error] = "Event creation failed!"
            redirect_to request.referer
        end
    end

    # Start editing an event.  Send the javascript response which will fill
    #  in the event edit form with the current event fields.
    def edit
        @event = Event.find_by_id(params[:id])
        respond_to do |format|
            format.html
            format.js
        end
    end

    # Update an event which was edit.
    def update
        @event = Event.find_by_id(params[:id])

        @event.title = params[:event][:title]
        @event.location = params[:event][:location]
        @event.calendar_id = params[:event][:calendar_id]
        @event.all_day = params[:event][:all_day]
        @event.notes = params[:event][:notes]
        parse_params

        if @event.save
            redirect_to request.referer
        else
            flash[:error] = "Event update failed!"
            redirect_to request.referer
        end
    end

    # Delete an event
    def destroy
        @event.destroy
        redirect_to request.referer
    end

  private

    # Valaidte the user, making sure they have read/write access to the calendar which
    #  owns the event being accessed
    def correct_user
        @event = Event.find_by_id(params[:id])
        if @event.nil?
            redirect_to root_url
        else
            @calendar = current_user.calendars.find_by_id(@event.calendar_id)
            if @calendar.nil?
                @calendar = 
                    current_user.subscriptions.find_by_calendar_id(@event.calendar_id)
            end
            redirect_to root_url if @calendar.nil?
        end
    end

end
