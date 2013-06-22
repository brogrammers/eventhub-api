class EventTimesValidator < ActiveModel::Validator
  def validate(record)
    unless record.start_time > Time.now
      record.errors[:start_time] << 'event start time must be in the future'
    end

    unless record.end_time > record.start_time
      record.errors[:end_time] << 'event must end after it starts'
    end
  end
end

class Event < ActiveRecord::Base
  attr_accessible :description, :end_time, :start_time, :name, :description

  has_many :destinations, :as => :choice, :dependent => :destroy

  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :offers ,:as => :offerer, :dependent => :destroy

  belongs_to :place

  validates :description, :name, :start_time, :end_time, :place, :presence => true
  validates :name, :length => { :minimum => 5, :maximum => 256 }
  validates :description, :length => { :minimum => 5, :maximum => 1024 }
  validates_with EventTimesValidator
end
