class Notification < ActiveRecord::Base
  attr_accessible :payload, :read, :title

  belongs_to :notifiable, :polymorphic => true
  belongs_to :user, :foreign_key => :notifiable_id, :class_name => 'CoreUser'

  def payload_hash
    JSON.parse(self.payload)
  rescue
    { }
  end
end
