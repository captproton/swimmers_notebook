require 'date'
require 'active_record'

class Effort < ActiveRecord::Base
  validates :name, presence: true  
  attr_accessor :notebook
  
  
  def publish(clock=DateTime)
    # return false unless valid?
    self.pubdate = clock.now
    @notebook.add_entry(self)
  end
end

