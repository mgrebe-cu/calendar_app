class EventsController < ApplicationController

    def create
        calendar = Calendar.where(default: true, user_id: current_user.id)[0]
        @event = calendar.events.build(params[:event])
        begin 
            @event.date = params[:event][:date].to_date
        rescue
            @event.date = nil
        end
        begin
            @event.start = (params[:event][:date] + ' ' + 
                            params[:event][:start]).to_time(:local)
        rescue
            @event.start = nil
        end
        begin
            @event.end = (params[:event][:date] + ' ' + 
                          params[:event][:end]).to_time(:local)
        rescue
            @event.end = nil
        end

        if @event.save
            flash[:success] = "Event created!"
            redirect_to current_user
        else
            flash[:error] = "Event creation failed!"
            redirect_to current_user
        end
    end
end
