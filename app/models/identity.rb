class Identity < ActiveRecord::Base
  attr_accessible :provider_id, :token

  belongs_to :identifiable, :polymorphic => true
  belongs_to :user, :foreign_key => 'identifiable_id', :class_name => 'CoreUser'
end
