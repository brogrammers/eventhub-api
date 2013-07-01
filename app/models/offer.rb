class Offer < ActiveRecord::Base
  attr_accessible :currency, :description, :end_time, :name, :price, :start_time
  belongs_to :offerer, :polymorphic => true
  validates :currency, :description, :end_time, :start_time, :name, :price, :offerer, :presence => true
end
