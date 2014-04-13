require_relative '../spec_helper_lite'
require_relative '../../app/models/remote_data'
require 'ostruct'


describe RemoteData do
  before do
    @it = RemoteData.new
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
      entry = Object.new
      @it.add_entry(entry)
      @it.entries.must_include(entry)
    end
  end
  
end