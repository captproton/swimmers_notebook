class Notebook
  attr_reader :entries
  attr_writer :effort_maker

  def initialize(entry_fetcher=Effort.method(:all))
    @entry_fetcher = entry_fetcher
  end
  
  def title
    "Swimmer's Notebook"
  end
  
  def subtitle
    "Swim Meet times with context"
  end
  
  def entries
    fetch_entries.sort_by{|e| e.pubdate}.reverse.take(10)
  end
  
  def new_effort(*args)
    effort_maker.call(*args).tap do |e|
      e.notebook = self
    end
  end
  
  def add_entry(entry)
    entry.save
  end
  
  private

  def fetch_entries
    @entry_fetcher.()
  end
  def effort_maker
    @effort_maker ||= Effort.method(:new)
  end
end