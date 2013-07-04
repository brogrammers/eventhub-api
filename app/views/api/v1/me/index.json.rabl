object @current_user => :me

attributes :id, :name, :availability

node :location do |user|
  partial('api/v1/me/location', :object => user.location)
end

node :groups_created do |user|
  partial('api/v1/me/group', :object => user.groups_created)
end

node :groups_member_of do |user|
  partial('api/v1/me/group', :object => user.groups_member_of)
end

node :groups_invited_to do |user|
  partial('api/v1/me/group', :object => user.groups_invited_to)
end

node :places do |user|
  partial('api/v1/me/place', :object => user.places)
end

node :location_posts do |user|
  partial('api/v1/me/location_post', :object => user.location_posts)
end

node :devices do |user|
  partial('api/v1/me/device', :object => user.devices)
end

node :notifications do |user|
  partial('api/v1/me/notification', :object => user.notifications)
end

node :identities do |user|
  partial('api/v1/me/identity', :object => user.identities)
end
