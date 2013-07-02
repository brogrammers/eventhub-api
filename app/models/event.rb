class Event < ActiveRecord::Base
  attr_accessible :description, :end_time, :start_time, :name, :description

  has_many :destinations, :as => :choice, :dependent => :destroy

  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :offers ,:as => :offerer, :dependent => :destroy

  belongs_to :place

  validates :description, :name, :start_time, :end_time, :place, :presence => true
  validates :name, :length => { :minimum => 5, :maximum => 256 }
  validates :description, :length => { :minimum => 5, :maximum => 1024 }
  validates_with EventhubApi::Validator::Event

  def visibility_type
    self.parent.visibility_type
  end

end
