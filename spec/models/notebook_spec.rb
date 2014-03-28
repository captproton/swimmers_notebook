require_relative '../spec_helper_lite'
require_relative '../../app/models/notebook'
require 'ostruct'


describe Notebook do
  before do
    @entries = []
    @it = Notebook.new(->{@entries})
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
    it "should add the entry to the notebook" do
      entry = stub!
      @it.add_entry(entry)
    end
  end  
end