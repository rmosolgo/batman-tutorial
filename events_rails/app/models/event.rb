class Event < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :starts_at
  # validates :ends_at
  belongs_to :venue
end
