class Event < ActiveRecord::Base
  attr_accessible :description, :end_time, :name, :start_time
end
