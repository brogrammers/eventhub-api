object @place => :place

attributes :name, :description

node :location do |place|
  partial('api/v1/me/location', :object => place.location)
end