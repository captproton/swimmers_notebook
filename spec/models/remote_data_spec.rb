require_relative '../spec_helper_lite'
require_relative '../../app/models/remote_data'
require 'ostruct'

describe RemoteData do
  before do
    @entries = []
    @it = RemoteData.new(->{@entries})
  end

  it "should have no entries" do
    @it.entries.must_be_empty
  end

  describe "#new_entry" do
    before do
      @new_event = OpenStruct.new
      @it.event_maker = ->{ @new_event }
    end

    it "should return a new event" do
      @it.new_event.must_equal @new_event
    end

    it "should set the event's remote_data reference to itself" do
      @it.new_event.remote_data.must_equal(@it)
    end

    it "should accept an attribute hash on behalf of the event maker" do
      event_maker = MiniTest::Mock.new
      event_maker.expect(:call, @new_event, [{:x => 42, :y => 'z'}])
      @it.event_maker = event_maker
      @it.new_event(:x => 42, :y => 'z')
      event_maker.verify
    end
  end

  describe "#add_entry" do
    it "should add the entry to the remote_data" do
      entry = stub!
      mock(entry).save
      @it.add_entry(entry)
      @it.entries.must_include(entry)
    end
  end
  
  describe "#entries" do
    def stub_entry_with_date(date)
      OpenStruct.new(:pubdate => DateTime.parse(date))
    end

    it "should be sorted in reverse-chronological order" do
      oldest = stub_entry_with_date("2011-09-09")
      newest = stub_entry_with_date("2011-09-11")
      middle = stub_entry_with_date("2011-09-10")

      @it.add_entry(oldest)
      @it.add_entry(newest)
      @it.add_entry(middle)
      @it.entries.must_equal([newest, middle, oldest])
    end

    it "should be limited to 10 items" do
      10.times do |i|
        @it.add_entry(stub_entry_with_date("2011-09-#{i+1}"))
      end
      oldest = stub_entry_with_date("2011-08-30")
      @it.add_entry(oldest)
      @it.entries.size.must_equal(10)
      @it.entries.wont_include(oldest)
    end
  end
end
