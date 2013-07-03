class Device < ActiveRecord::Base
  attr_accessible :name, :token

  belongs_to :device_compatible, :polymorphic => true
  belongs_to :user, :foreign_key => :device_compatible_id, :class_name => 'CoreUser'

  validates :name, :token, :presence => true
end
