class Effort
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  
  attr_accessor :notebook, :name, :age
  
  def initialize(attrs={})
    attrs.each do |k, v|
      send("#{k}=", v)
    end
    
  end
  
  def persisted?
    false
  end
  
  def publish
    notebook.add_entry(self)
  end
end

