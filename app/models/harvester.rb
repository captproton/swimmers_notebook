require 'json'
require 'nokogiri'
require 'open-uri'
require 'active_support/all'
require 'httparty'

require_relative './swim_connection_scraper.rb'

class Harvester
  
  attr_reader :entries
  attr_accessor :notebook
  
  include HTTParty
  # base_uri "http://www.swimconnection.com"
  
  def initialize
    @entries = []
  end
  
  def title
    "Collecting Swim Data"
  end

  def get_or_create_parent_swim_meet_and_event_ids(swimconnection_com_meet_id, swimconnection_com_swim_meet_event_id)
    # swim_meet_id and event_id refers to our DB, not swimconnection_com
    @sed = swimconnection_event_details(swimconnection_com_meet_id, swimconnection_com_swim_meet_event_id)
    event_params = @sed.except(:parent_swim_meet_title)
    @parent_event =  Event.where(event_params).first_or_create
    
    #get or create parent SwimMeet    
    swim_meet_params = {swimconnection_com_id: Array(swimconnection_com_meet_id).first.to_s}
    @parent_swim_meet = SwimMeet.where(swim_meet_params).first_or_create
    
    #return database ID's of the parents
    @parents= {event_id: @parent_event.id, swim_meet_id: @parent_swim_meet.id}
    
  end
  
  def create_or_update_event_efforts(swimconnection_com_meet_id, swimconnection_com_swim_meet_event_id)
    @efforts ={}
    @swimconnection_efforts = self.list_of_event_efforts(swimconnection_com_meet_id, swimconnection_com_swim_meet_event_id)
    @parents = self.get_or_create_parent_swim_meet_and_event_ids(swimconnection_com_meet_id,
                                                                swimconnection_com_swim_meet_event_id)
    event_id = @parents[:event_id]
    swim_meet_id = @parents[:swim_meet_id]
    @swimconnection_efforts.each do |se|
      effort_params = { name: se[:name], age: se[:age].to_s, event_id: event_id, swim_meet_id: swim_meet_id }
      puts effort_params
      puts "-------------"
      @effort = Effort.where(effort_params).first_or_create
    end
    @efforts
  end

  def list_of_swim_meet_events(swimconnection_com_meet_id)
    swimconnection_com_meet_id = Array(swimconnection_com_meet_id).first
    swim_meet_events = []
    page_url = "http://www.swimconnection.com/pc/sa/meets/meet_#{swimconnection_com_meet_id}/eventsAgeEvent.html"
    
    response = fetch_page(page_url)

    swim_meet_events = SwimConnectionScraper.new(response).scrape_event_index
    
  end
  
  def list_of_event_efforts(swimconnection_com_meet_id, swimconnection_com_swim_meet_event_id)
    swimconnection_com_swim_meet_event_id = Array(swimconnection_com_swim_meet_event_id).first.to_s
    swimconnection_com_meet_id = Array(swimconnection_com_meet_id).first.to_s
    page_url = "http://www.swimconnection.com/pc/exec/MeetResultsRightEventDispatch?meetSeqNo=#{swimconnection_com_meet_id}&round=-1&eventInfo=#{swimconnection_com_swim_meet_event_id}"
    
    response = fetch_page(page_url)

    efforts = SwimConnectionScraper.new(response).convert_event_efforts_table_into_an_array
    
    efforts.each do |effort|
      final_time = effort[:final_time]
      final_time = text_to_milliseconds(final_time)
      effort[:final_time] = final_time
      effort[:swimconnection_com_swim_meet_event_id ] = swimconnection_com_swim_meet_event_id
      effort[:swimconnection_com_meet_id ] = swimconnection_com_meet_id
    end
    
    efforts
  end
  
  
  def list_of_swim_meets
    page_url = "http://www.swimconnection.com/pc/exec/Meets"
    @swim_meets = []
    
    response = fetch_page(page_url)
    

    return @swim_meets = [] if response.blank?
    # Get the body of text within the tag we want and create an array of swim meet details from that text.
    rows = Nokogiri::HTML(response).css('table tr td table tr')    
    
    rows.each do |row|
  
      anchor = Array(row.css('td:nth-child(2) a'))
      # parse link for details of meet
      if Array(anchor).length > 0
        link =  row.css('td:nth-child(2) a').attribute('href').value
        link_params = CGI::parse(link)
        meet_seq_no = link_params['/pc/exec/MeetResultsDispatch?meetSeqNo'].first.to_s
        
        swim_meet_obj = create_swim_meet_obj(row, meet_seq_no)
      
        @swim_meets << swim_meet_obj unless meet_seq_no.blank?
      end
    end
    @swim_meets
  end
  
  def update_local_list_of_swim_meets
    @swim_connection_com_meets = self.list_of_swim_meets
    
    @swim_connection_com_meets.each do |sc_meet|
      # SwimMeet(id: integer, title: string, started_on: datetime, finished_on: datetime, courses: string, location: string, location_url: text, results_url: text, created_at: datetime, updated_at: datetime, swimconnection_com_id: string)
      #  => {:date=>" 2012-07-27 ", :name=>"REDWOOD EMPIRE SWIM LEAGUE", :link=>"/pc/exec/MeetResultsDispatch?meetSeqNo=2823&teamCode=", :meet_seq_no=>"2823", :course=>"25Y", :location=>" EL CERRITO SWIM CENT "} 
      meet_params = {title: sc_meet[:name], started_on: sc_meet[:date], finished_on: sc_meet[:date], courses: sc_meet[:course], location: sc_meet[:location], location_url: sc_meet[:link], results_url: sc_meet[:link], swimconnection_com_id: sc_meet[:meet_seq_no]}
      @meet = SwimMeet.where(swimconnection_com_id: sc_meet[:meet_seq_no])
      SwimMeet.create(meet_params) if @meet.count == 0
    end
  end
  
  def create_or_update_event_efforts_for_swim_meet(swimconnection_com_meet_id)
    @swim_connection_events = self.list_of_swim_meet_events(swimconnection_com_meet_id)
    @swim_connection_events.each do |swimconnection_com_swim_meet_event_id|
      puts '========================'
      puts "Current Event:  #{swimconnection_com_swim_meet_event_id}"
      puts '------------------------'
      self.create_or_update_event_efforts(swimconnection_com_meet_id, swimconnection_com_swim_meet_event_id)
    end
  end
  
  
  
  private

  def fetch_page(page_url)
    response = HTTParty.get(page_url)
    
    if response.code != 200
      puts "Error #{response.code}: #{response.message}"
      response = ""
    end
    
    return response    
  end

  def create_swim_meet_obj(row, meet_seq_no)
    swim_meet_obj = {
      :date => row.css('td:nth-child(1)').text.strip!,
      :name => row.css('td:nth-child(2) a').text,
      :link => row.css('td:nth-child(2) a').attribute('href').value,
      :meet_seq_no => meet_seq_no,
      :course => row.css('td:nth-child(3)').text.strip!,
      :location => row.css('td:nth-child(4)').text.strip!
    }
    
  end
    
  def text_to_milliseconds(time_in_text)
    string = Array(time_in_text).first.to_s
    return 0 if string.blank? 
      
    hrs=0, min=0, sec=0
    
    sec = string.split(":")[-1].to_f
    min = string.split(":")[-2].to_i
    hrs = string.split(":")[-3].to_i

    milliseconds = ((hrs*3600 + min*60 + sec) * 1000).to_i
  end

  def swimconnection_event_details(swimconnection_com_meet_id, swimconnection_com_swim_meet_event_id)
    swimconnection_com_swim_meet_event_id = Array(swimconnection_com_swim_meet_event_id).first.to_s
    swimconnection_com_meet_id = Array(swimconnection_com_meet_id).first.to_s
    @event = {} #initialize event that will be returned
    
    #collect details about event
    page_url = "http://www.swimconnection.com/pc/exec/MeetResultsRightEventDispatch?meetSeqNo=#{swimconnection_com_meet_id}&round=-1&eventInfo=#{swimconnection_com_swim_meet_event_id}"
    
    
    response = HTTParty.get(page_url)
    
    if response.code != 200
      puts "page currently not available"
      return @event
    end
    
    # Get the body of text within the tag we want and create a title from that text.
    page=Nokogiri::HTML(response)
    
    parent_swim_meet_title = page.css('table').first.css("table").css("td.subtitle").text.strip!
    
    event_details =  page.css('table').first.css("table").css("td.hilite").text.strip!.split("\r\n").each {|e| e.strip!}

    title  = "#{event_details[0]} #{event_details[1]} - #{event_details[3]} #{event_details[4]}"
    
    @event = {title: title, results_url: page_url, parent_swim_meet_title: parent_swim_meet_title}
  end


end