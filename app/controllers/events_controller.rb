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
            if @event.all_day
                start_t = params[:event][:date]
                @event.start = DateTime.strptime(start_t, "%m/%d/%Y").to_time
            else
                start_t = params[:event][:date] + ' ' + params[:event][:start]
                @event.start = DateTime.strptime(start_t, "%m/%d/%Y %H:%M %p").to_time
            end
        rescue
            @event.start = nil
        end
        begin
            if @event.all_day
                end_t = params[:event][:date]
                @event.end = DateTime.strptime(end_t, "%m/%d/%Y").to_time
            else
                end_t = params[:event][:date] + ' ' + params[:event][:end]
                @event.end = DateTime.strptime(end_t, "%m/%d/%Y %H:%M %p").to_time
            end
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

    def destroy
        event = Event.find_by_id(params[:id])
        event.destroy
        redirect_to user_path(current_user)
    end

    def update
        @event = Event.find(params[:id])
        respond_to do |format|
        if @event.update_attributes(params[:house])
            format.js 
        else
            format.js
        end
    end
end
