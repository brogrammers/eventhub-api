object @group => :groups

attributes :id, :name, :description

node :chatroom do |group|
  partial('api/v1/groups/chatroom', :object => group.chatroom)
end

node :creator do |group|
  partial('api/v1/groups/creator', :object => group.creator)
end

node :destinations do |group|
  partial('api/v1/groups/destinations', :object => group.destinations)
end

node :members do |group|
  partial('api/v1/groups/members', :object => group.members)
end

node :invited do |group|
  partial('api/v1/groups/invited', :object => group.invited)
end

