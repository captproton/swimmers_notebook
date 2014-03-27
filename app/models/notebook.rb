class Notebook
  attr_reader :entries
  attr_writer :effort_maker
  
  def initialize
    @entries = []
  end
  
  def title
    "Swimmer's Notebook"
  end
  
  def subtitle
    "Swim Meet times with context"
  end
  
  def entries
    @entries.sort_by{|e| e.pubdate}.reverse.take(10)
  end
  
  def new_effort(*args)
    effort_maker.call(*args).tap do |e|
      e.notebook = self
    end
  end
  
  def add_entry(entry)
    @entries << entry
  end
  
  private
  
  def effort_maker
    @effort_maker ||= Effort.method(:new)
  end
end