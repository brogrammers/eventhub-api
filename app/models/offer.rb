class Offer < ActiveRecord::Base
  attr_accessible :currency, :description, :end_time, :name, :price, :start_time
end
