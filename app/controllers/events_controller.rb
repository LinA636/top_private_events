class EventsController < ApplicationController
    helper_method :attending_event?

    def index
        @past_events = Event.past_events
        @upcoming_events = Event.upcoming_events
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

    def edit
        @event = Event.find(params[:id])
    end

    def update
        @event = Event.find(params[:id])

        if @event.update(event_params)
            redirect_to event_path(@event),notice: 'Event was successfully updated.'
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @event = Event.find(params[:id])
        @event.destroy

        redirect_to user_path(current_user), notice: 'Event was successfully destroyed.'      
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

        redirect_to determine_redirect_path
    end

    private

    def event_params
        params.require(:event).permit(:title, :description, :event_date)      
    end

    def attending_event?(user, event)
        user.attended_events.include?(event)
    end

    def determine_redirect_path
        if request.referer == event_url(@event)
            return event_path(@event)
        elsif request.referer == events_url
            return events_path
        else
            return event_path(@event)
        end
    end
end
