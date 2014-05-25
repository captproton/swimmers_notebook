require 'date'
require 'active_record'

class Event < ActiveRecord::Base

  has_many :efforts
  has_many :swim_meets, through: :efforts
  
end