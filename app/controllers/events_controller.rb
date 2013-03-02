class EventsController < ApplicationController

    def create
        calendar = Calendar.where(default: true, user_id: current_user.id)[0]
        @event = calendar.events.build(params[:event])
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
                @event.start = DateTime.strptime(start_t, "%m/%d/%Y")
            else
                start_t = params[:event][:start_date] + ' ' + params[:event][:start] + ' ' + zone
                @event.start = DateTime.strptime(start_t, "%m/%d/%Y %H:%M %p %Z")
            end
        rescue
            @event.start = nil
        end
        begin
            if @event.all_day
                end_t = params[:event][:end_date]
                @event.end = DateTime.strptime(end_t, "%m/%d/%Y")
            else
                end_t = params[:event][:end_date] + ' ' + params[:event][:end] + ' ' + zone
                @event.end = DateTime.strptime(end_t, "%m/%d/%Y %H:%M %p %Z")
            end
        rescue
            @event.end = nil
        end

        if @event.save
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

end
