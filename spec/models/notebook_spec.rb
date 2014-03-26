require 'minitest/autorun'
require_relative '../../app/models/notebook'


describe Notebook do
  before do
    @it = Notebook.new
  end
  
  it "should have no entries" do
    @it.entries.must_be_empty
  end
end