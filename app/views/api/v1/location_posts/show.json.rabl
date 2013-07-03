object @location_post

attributes :content

node :location do |post|
  partial('api/v1/locations/show', :object => post.location)
end