class Place < ActiveRecord::Base
  attr_accessible :description, :name

  belongs_to :creator, :foreign_key => :creator_id, :class_name => 'CoreUser'
  has_one :location, :as => :locationable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :destinations, :as => :choice, :foreign_key => 'choice_id', :dependent => :destroy
  has_many :offers ,:as => :offerer, :dependent => :destroy
  has_many :events, :dependent => :destroy


  validates :location, :description, :name, :presence => true
  validates :name, :length => { :minimum => 5, :maximum => 256 }
  validates :description, :length => { :minimum => 5, :maximum => 1024 }
end
