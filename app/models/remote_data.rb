class RemoteData
  attr_reader :entries
  attr_writer :event_maker
  
  def initialize
    @entries = []
  end
  
  def title
    "Collecting Swim Data"
  end

  def entries
    @entries.sort_by{ |e| e.pubdate.reverse.take(10)}
  end
  def new_event(*args)
    event_maker.call(*args).tap do |e|
      e.remote_data = self
    end
  end
  
  def add_entry(entry)
    @entries << entry
  end
  
  private
  
  def event_maker
    @event_maker ||= Event.method(:new)
  end
end

