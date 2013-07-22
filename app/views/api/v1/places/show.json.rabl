object @place => :place

attributes :id, :name, :description, :visibility_type

node :location do |place|
  partial('api/v1/places/location', :object => place.location)
end

node :creator do |place|
  partial('api/v1/places/creator', :object => place.creator)
end

node :comments do |place|
  partial('api/v1/places/comment', :object => place.comments)
end

# TODO: Add destinations, offers, events