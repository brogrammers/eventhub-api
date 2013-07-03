object @current_user => :me

attributes :name, :availability

node :location do |user|
  partial('api/v1/locations/show', :object => user.location)
end

node :friends do |user|
  partial('api/v1/friends/show', :object => (user.friends + user.inverse_friends))
end

node :groups_created do |user|
  partial('api/v1/groups/show', :object => user.groups_created)
end

node :places do |user|
  partial('api/v1/places/show', :object => user.places)
end

node :location_posts do |user|
  partial('api/v1/location_posts/show', :object => user.location_posts)
end

node :devices do |user|
  partial('api/v1/devices/show', :object => user.devices)
end

node :notifications do |user|
  partial('api/v1/notifications/show', :object => user.notifications)
end

node :identities do |user|
  partial('api/v1/identities/show', :object => user.identities)
end