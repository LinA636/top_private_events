class EventsController < ApplicationController
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

    def add_attendance
        @event = Event.find(params[:id])
        @user = current_user

        attendance = Attendance.new(attendee: @user, attended_event: @event)

        if attendance.save
            flash[:success] = "Attendance record created successfully."
        else
            flash[:error] = "Error creating attendace record: #{attendance.errors.full_messages.join(', ')}"
        end

        redirect_to @event
    end

    def remove_attendance
        @event = Event.find(params[:id])
        @user = current_user
        attendance = Attendance.find_by(attendee: @user)

        if attendance
            attendance.destroy
        else
            flash[:error] = "Error deleting attendance record: #{attendance.errors.full_messages.join(', ')}"
            return false
        end

        redirect_to @event
    end

    private

    def event_params
        params.require(:event).permit(:title, :description)      
    end
end
