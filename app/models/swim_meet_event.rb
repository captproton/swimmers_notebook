class SwimMeetEvent < ActiveRecord::Base
  belongs_to :swim_meet
  belongs_to :event
end
