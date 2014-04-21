require 'date'
require 'active_record'

class Effort < ActiveRecord::Base
  validates :name, presence: true  
  attr_accessor :notebook
  
  def self.most_recent(limit=10)
    # all(order: "pubdate DESC", limit: limit)
    order("pubdate DESC").limit(limit)
    
  end
  
  def publish(clock=DateTime)
    # return false unless valid?
    self.pubdate = clock.now
    @notebook.add_entry(self)
  end
end

