require_relative '../../app/models/harvester'

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Harvester do
  
  
  describe "#list_of_swim_meets" do
    subject { Harvester.new.list_of_swim_meets }
 
    # it 'works' do
    #   subject.should =~ [ 4, 2, 3 ]
    # end
    
    
    it "#list_of_swim_meets should return more than 290 swim meets" do
      subject.size.should be > 290 #success!
      # subject.size.should be < 10
      # subject.last.should be nil
      # subject.last[:meet_seq_no].should be '1000'
      # expect(subject.last[:meet_seq_no]).to eq("2823")
      # expect(subject).to be_nil
    
    end
    it "#list_of_swim_meets should return less than 300 swim meets" do
      subject.size.should be < 300    
    end
    it "the last meet in #list_of_swim_meets should have a meet_seq_no equal to 2823" do
      expect(subject.last[:meet_seq_no]).to eq("2823")
    end
  end
  
  describe "#list_of_swim_meet_events" do
    # subject { Harvester.new.list_of_swim_meet_events(stub) }
    # subject { Harvester.new.list_of_swim_meet_events(:swimconnection_com_meet_id => "2823") }​​
    subject { Harvester.new.list_of_swim_meet_events("2823") }
    
    it "is an Array" do
      # subject.should eq('something')
      subject.should be_an Array
    end
    
    it "has a size greater than 10 events" do
      subject.size.should be > 10
    end
    
    it "has a last item equal to 'M000822'" do
      subject.last.should eq "M000822"
    end
  end
  
end


