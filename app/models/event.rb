require 'date'
class Event # < ActiveRecord::Base
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :remote_data, :title, :raw_text, :pubdate
  
  # belongs_to :swim_meet
  
  def initialize(attrs={})
    attrs.each do |k,v| send("#{k}=",v) end 
  end
  
  def publish(clock=DateTime)
    self.pubdate = clock.now
    remote_data.add_entry(self)
  end

  def persisted?
    false
  end
end