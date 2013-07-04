object @location_post => :location_post

attributes :content

node :location do |post|
  partial('api/v1/me/location', :object => post.location)
end