class Vote < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :destination
  belongs_to :user
end
