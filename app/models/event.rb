class Event # < ActiveRecord::Base
  attr_accessor :remote_data, :title, :raw_text
  
  # belongs_to :swim_meet
  
  def initialize(attrs={})
    attrs.each do |k,v| send("#{k}=",v) end 
  end
  
  def publish
    remote_data.add_entry(self)
  end
  
end