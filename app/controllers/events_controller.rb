class EventsController < ApplicationController
    before_filter :signed_in_user
    before_filter :correct_user,   only: :destroy

    def parse_params
        zone = Time.now.zone
        begin 
            @event.start_date = Date.strptime(params[:event][:start_date],'%m/%d/%Y')
        rescue
            @event.start_date = nil
        end
        begin 
            @event.end_date = Date.strptime(params[:event][:end_date],'%m/%d/%Y')
        rescue
            @event.end_date = nil
        end
        begin
            if @event.all_day
                start_t = params[:event][:start_date]
                @event.start_time = DateTime.strptime(start_t, "%m/%d/%Y")
            else
                start_t = params[:event][:start_date] + ' ' + params[:event][:start_time] + ' ' + zone
                @event.start_time = DateTime.strptime(start_t, "%m/%d/%Y %H:%M %p %Z")
            end
        rescue
            @event.start_time = nil
        end
        begin
            if @event.all_day
                end_t = params[:event][:end_date]
                @event.end_time = DateTime.strptime(end_t, "%m/%d/%Y")
            else
                end_t = params[:event][:end_date] + ' ' + params[:event][:end_time] + ' ' + zone
                @event.end_time = DateTime.strptime(end_t, "%m/%d/%Y %H:%M %p %Z")
            end
        rescue
            @event.end_time = nil
        end
    end

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

    def edit
        @event = Event.find_by_id(params[:id])
        #session[:return_to] ||= request.referer
        respond_to do |format|
            format.html
            format.js
        end
    end

    def update
        @event = Event.find_by_id(params[:id])

        # todo  Is there a way to update the params struct with parse 
        # instead?
        @event.title = params[:event][:title]
        @event.location = params[:event][:location]
        @event.all_day = params[:event][:all_day]
        @event.notes = params[:event][:notes]
        parse_params

        if @event.save
            #redirect_to session[:return_to]
            redirect_to request.referer
        else
            flash[:error] = "Event update failed!"
            #redirect_to session[:return_to]
            redirect_to request.referer
        end
    end

    def destroy
        @event.destroy
        redirect_to request.referer
    end

  private

    def correct_user
        @event = Event.find_by_id(params[:id])
        if @event.nil?
            redirect_to root_url
        else
            @calendar = current_user.calendars.find_by_id(@event.calendar_id)
            redirect_to root_url if @calendar.nil?
        end
    end

end
