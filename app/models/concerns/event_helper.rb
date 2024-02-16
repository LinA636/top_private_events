module EventHelper
    def event_in_past?
        event_date < Date.current
    end
end