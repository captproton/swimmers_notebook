require 'minitest/autorun'
require_relative '../spec_helper_lite'

stub_module 'ActiveModel::Conversion'
stub_module 'ActiveModel::Naming'

require_relative '../../app/models/event'

describe Event do
  before do
    @it = Event.new
  end
  
  it "should support setting attributes in the initializer" do
    it = Event.new(:title => "Swimmer Name", :raw_text => "8")
    it.title.must_equal "Swimmer Name"
    it.raw_text.must_equal "8"
  end
  
  it "should start with blank attributes" do
    @it.title.must_be_nil
    @it.raw_text.must_be_nil
  end

  
  it "should support reading and writing a title" do
    @it.title = "50 Free"
    @it.title.must_equal "50 Free"
  end
  
  it "should support the reading and writing an event raw_text" do
    @it.raw_text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
    @it.raw_text.must_equal "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
  end
  
  it "should support the reading and writing a remote_data reference" do
    remote_data = Object.new
    @it.remote_data = remote_data
    @it.remote_data.must_equal remote_data
  end
  
  describe "#publish" do
    before do
      @remote_data = Minitest::Mock.new
      @it.remote_data = @remote_data
    end
    
    after do
      @remote_data.verify
    end
    
    it "should add the event to the remote_data" do
      @remote_data.expect :add_entry, nil, [@it]
      @it.publish      
    end
  end

  describe "#pubdate" do
    describe "before publishing" do
      it "should be blank" do
        @it.pubdate.must_be_nil
      end
    end

    describe "after publishing" do
      before do
        @clock = stub!
        @now = DateTime.parse("2011-09-11T02:56")
        stub(@clock).now(){@now}
        @it.remote_data = stub!
        @it.publish(@clock)
      end

      it "should be a datetime" do
        @it.pubdate.class.must_equal(DateTime)
      end

      it "should be the current time" do
        @it.pubdate.must_equal(@now)
      end
    end
  end

  
end

