class EventsController < ApplicationController

    def create
        calendar = Calendar.where(default: true, user_id: current_user.id)[0]
        @event = calendar.events.build(params[:event])
        begin 
            @event.date = Date.strptime(params[:event][:date],'%m/%d/%Y')
        rescue
            @event.date = nil
        end
        begin
            start_t = params[:event][:date] + ' ' + params[:event][:start]
            @event.start = DateTime.strptime(start_t, "%m/%d/%Y %H:%M %p").to_time
        rescue
            @event.start = nil
        end
        begin
            end_t = params[:event][:date] + ' ' + params[:event][:end]
            @event.end = DateTime.strptime(end_t, "%m/%d/%Y %H:%M %p").to_time
        rescue
            @event.end = nil
        end

        if @event.save
            #flash[:success] = "Event created!"
            redirect_to current_user
        else
            flash[:error] = "Event creation failed!"
            redirect_to current_user
        end
    end
end
