class Image < ActiveRecord::Base
  belongs_to :vehicle
  attr_accessible :name, :url, :view, :vehicle
end
