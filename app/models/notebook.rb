class Notebook
  attr_reader :entries
  def initialize
    @entries = []
  end
  
  def title
    "Swimmer's Notebook"
  end
  
  def subtitle
    "Swim Meet times with context"
  end
  
end