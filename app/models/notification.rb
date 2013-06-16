class Notification < ActiveRecord::Base
  attr_accessible :payload, :read, :title
end
