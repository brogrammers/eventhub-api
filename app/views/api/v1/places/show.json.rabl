object @place

attributes :name, :description

node :location do |place|
  partial('api/v1/locations/show', :object => place.location)
end