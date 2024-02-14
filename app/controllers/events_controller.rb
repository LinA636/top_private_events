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

    private

    def event_params
        params.require(:event).permit(:title, :description)      
    end
end
