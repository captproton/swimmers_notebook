require_relative '../spec_helper_full'

describe Notebook do
  include SpecHelpers
  before do
    setup_database
    @it = Notebook.new
  end
  
  after do
    teardown_database
  end

  describe "#entries" do
    def make_entry_with_date(date)
      @it.new_effort(:pubdate => DateTime.parse(date), :name => date)
    end

    it "should be sorted in reverse-chronological order" do
      oldest = make_entry_with_date("2011-09-09")
      newest = make_entry_with_date("2011-09-11")
      middle = make_entry_with_date("2011-09-10")

      @it.add_entry(oldest)
      @it.add_entry(newest)
      @it.add_entry(middle)
      @it.entries.must_equal([newest, middle, oldest])
    end

    it "should be limited to 10 items" do
      10.times do |i|
        @it.add_entry(make_entry_with_date("2011-09-#{i+1}"))
      end
      oldest = make_entry_with_date("2011-08-30")
      @it.add_entry(oldest)
      @it.entries.size.must_equal(10)
      @it.entries.wont_include(oldest)
    end
  end
end