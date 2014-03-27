require 'minitest/autorun'
require_relative '../spec_helper_lite'

stub_module 'ActiveModel::Conversion'
stub_module 'ActiveModel::Naming'

require_relative '../../app/models/effort'

describe Effort do
  before do
    @it = Effort.new
  end
  
  it "should support setting attributes in the initializer" do
    it = Effort. new(:name => "Swimmer Name", :age => "8")
    it.name.must_equal "Swimmer Name"
    it.age.must_equal "8"
  end
  
  it "should start with blank attributes" do
    @it.name.must_be_nil
    @it.age.must_be_nil
  end

  
  it "should support reading and writing a name" do
    @it.name = "Mary"
    @it.name.must_equal "Mary"
  end
  
  it "should support the reading and writing an age" do
    @it.age = "8"
    @it.age.must_equal "8"
  end
  
  it "shold support the reading and writing a notebook reference" do
    notebook = Object.new
    @it.notebook = notebook
    @it.notebook.must_equal notebook
  end
  
  describe "#publish" do
    before do
      @notebook = Minitest::Mock.new
      @it.notebook = @notebook
    end
    
    after do
      @notebook.verify
    end
    
    it "should add the effort to the notebook" do
      @notebook.expect :add_entry, nil, [@it]
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
        @it.notebook = stub!
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