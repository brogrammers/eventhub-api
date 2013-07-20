object @object => :error

node :messages do |record|
  record.errors.full_messages
end