class Event < ApplicationRecord
    belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
    has_many :attendances, foreign_key: 'attended_event_id', dependent: :destroy
    has_many :attendees, through: :attendances, source: :attendee

    validates :title, presence: true
    validates :description, presence: true
    validates :event_date, presence: true
end
