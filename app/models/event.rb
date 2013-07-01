class Event < ActiveRecord::Base
  attr_accessible :description, :end_time, :start_time, :name, :description, :visibility_type

  has_many :destinations, :as => :choice, :dependent => :destroy

  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :offers ,:as => :offerer, :dependent => :destroy

  belongs_to :place

  validates :description, :name, :start_time, :end_time, :place, :presence => true
  validates :name, :length => { :minimum => 5, :maximum => 256 }
  validates :description, :length => { :minimum => 5, :maximum => 1024 }
  validates :visibility_type, :inclusion => { :in => %w(public private certified)}
  validates_with EventhubApi::Validator::Event
end
