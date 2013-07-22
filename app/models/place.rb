class Place < ActiveRecord::Base
  attr_accessible :description, :name, :visibility_type

  as_enum :visibility_type, [ :public, :private, :certified ], :whiny => false

  belongs_to :creator, :foreign_key => :creator_id, :class_name => 'CoreUser'
  has_one :location, :as => :locationable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :destinations, :as => :choice, :foreign_key => 'choice_id', :dependent => :destroy
  has_many :offers ,:as => :offerer, :dependent => :destroy
  has_many :events, :dependent => :destroy


  validates :location, :description, :name, :visibility_type, :presence => true
  validates :name, :length => { :minimum => 5, :maximum => 256 }
  validates :description, :length => { :minimum => 5, :maximum => 1024 }
  validates :visibility_type, :as_enum => true

  def can_be_seen_by?(user)
    self.visibility_type == :private # TODO: solve if user can see private place
  end

  def can_be_modified_by?(user)
    self.creator == user
  end

  class << self
    def all_within(latitude, longitude, offset)
      places = [ ]
      Location.all_within(latitude, longitude, offset).each do |location|
        begin
          places << Place.find(location.locationable_id) if location.locationable_type == 'Place'
        rescue ActiveRecord::RecordNotFound
          # ignore for now
        end
      end
      places
    end
  end
end
