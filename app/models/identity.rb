class Identity < ActiveRecord::Base
  attr_accessible :provider_id, :token, :provider

  as_enum :provider, [ :eventhub, :facebook ]

  belongs_to :identifiable, :polymorphic => true
  belongs_to :user, :foreign_key => 'identifiable_id', :class_name => 'CoreUser'

  validates :provider, :as_enum => true
  validates :provider_id, :token, :presence => true
end
