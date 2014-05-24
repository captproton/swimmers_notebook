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
    it "#list_of_swim_meets should return less than 325 swim meets" do
      subject.size.should be < 325
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
    
    it "has a size of 132 events" do
      subject.size.should be 132
    end
    
    it "has a last item equal to 'M000822'" do
      subject.last.should eq "M000822"
    end
  end
  
  
  describe "#list_of_event_efforts" do
    subject { Harvester.new.list_of_event_efforts("2823", "M000822") }
    
    it 'works' do
      subject.should =~ [{:rank=>1, :name=>" LOMVARDAS, AKIRA T", :age=>8, :team=>" PC\u0095NBA ", :final_time=>85800, :standard=>"PRT", :swimconnection_com_swim_meet_event_id=>"M000822", :swimconnection_com_meet_id=>"2823"}, {:rank=>2, :name=>" LARSEN, MATTHEW E", :age=>8, :team=>" PC\u0095NVST ", :final_time=>105880, :standard=>"A", :swimconnection_com_swim_meet_event_id=>"M000822", :swimconnection_com_meet_id=>"2823"}, {:rank=>3, :name=>" ABRAHAMSON, MOSES J", :age=>8, :team=>" PC\u0095BBR ", :final_time=>106440, :standard=>"A", :swimconnection_com_swim_meet_event_id=>"M000822", :swimconnection_com_meet_id=>"2823"}, {:rank=>4, :name=>" MANALANG, JENALD C", :age=>8, :team=>" PC\u0095ECG ", :final_time=>110509, :standard=>"B", :swimconnection_com_swim_meet_event_id=>"M000822", :swimconnection_com_meet_id=>"2823"}, {:rank=>5, :name=>" WATSON, DERIN A", :age=>8, :team=>" PC\u0095MONT ", :final_time=>0, :standard=>"", :swimconnection_com_swim_meet_event_id=>"M000822", :swimconnection_com_meet_id=>"2823"}]
    end
    
    it "is an Array" do
      # subject.should eq('something')
      subject.should be_an Array
    end
    
    it "has a size of 132 events" do
      subject.size.should be 5
    end

  end
  
end


