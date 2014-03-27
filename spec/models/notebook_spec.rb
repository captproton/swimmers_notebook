require 'minitest/autorun'
require_relative '../spec_helper_lite'
require_relative '../../app/models/notebook'
require 'ostruct'


describe Notebook do
  before do
    @it = Notebook.new
  end
  
  it "should have no entries" do
    @it.entries.must_be_empty
  end
  
  describe "new entry" do
    before do
      @new_effort = OpenStruct.new
      @it.effort_maker = ->{ @new_effort }
    end
    
    it "should return a new effort" do
      @it.new_effort.must_equal @new_effort
    end
    
    it "should set the effort's notebook reference to itself" do
      @it.new_effort.notebook.must_equal(@it)
    end
    
    # it "should accept an attribute hash on behalf of the effort maker" do
    #   effort_maker = MiniTest::Mock.new
    # end
  end
  
  describe "#add_entry" do
    it "should add the entry to the blog" do
      entry = stub!
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