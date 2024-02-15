class EventsController < ApplicationController
    helper_method :attending_event?

    def index
        @events = Event.all
    end

    def new
      @event = Event.new
    end

    def create 
        @event = current_user.created_events.build(event_params)
        
        if @event.save
            redirect_to events_path, notice: 'Event was successfully created.'
        else
            render :new,  status: :unprocessable_entity
        end
    end

    def show
        @event = Event.find(params[:id])      
    end

    def toggle_attendance
        @event = Event.find(params[:id])
        @user = current_user

        attendance = Attendance.find_by(attendee: @user, attended_event: @event)
        
        if attendance
            attendance.destroy
            flash[:notice] = "You have been removed from the event."
        else
            attendance = Attendance.new(attendee: @user, attended_event: @event)
            attendance.save
            flash[:notice] = "You have added to the event."
        end

        redirect_to @event
    end

    private

    def event_params
        params.require(:event).permit(:title, :description)      
    end

    def attending_event?(user, event)
        user.attended_events.include?(event)
    end
end
