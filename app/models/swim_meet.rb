class SwimMeet < ActiveRecord::Base
  has_many :efforts
  has_many :events, through:  :efforts
end
