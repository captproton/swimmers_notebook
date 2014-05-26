require 'json'
require 'nokogiri'
require 'open-uri'
require 'active_support/all'

class SwimConnectionScraper
  
  attr_reader :response
  
  def initialize(response)
    @response = response
  end  
  
  def scrape_event_index
    swim_meet_events = []
    
    # Get the body of text within the javascript tag we want and create an array of lines from that text.
    page=Nokogiri::HTML(response.body)
    string = page.css('head').css('script').last.content
    lines = string.lines
    
    # Now, whittle down the array to the desired elements within the javascript getCurrent() function of the fetched page
    # and insert it into the @swim_meet_events
    index_of_start_of_function = lines.each_index.select{|i| lines[i] =~ /function updateCurrent/}.first
    index_of_end_of_function = (lines.each_index.select{|i| lines[i] =~ /function getIndex/}).first - 1
    lines_of_function = lines[index_of_start_of_function, index_of_end_of_function]
    
    # Find ID's of events and add them to an array
    lines_of_function.each do |element|
      id = element.match(/'\w+'/).to_s.gsub!("'","")
      swim_meet_events << id if id != nil
    end
    
    return swim_meet_events
  end
  
  def convert_event_efforts_table_into_an_array
    efforts =[]
    
    page=Nokogiri::HTML(response)
    table =  page.css('table').last
    rows = table.css('tr').select{|row| row['bgcolor'] == '#ffffff'}
    
    rows.each do |row|
      rank = row.css('td:nth-child(1)').text.strip!
      rank = Array(rank).first.to_i 
      age = row.css('td:nth-child(3)').text.strip!
      age = Array(age).first.to_i
      
      final_time = row.css('td:nth-child(5)').text.strip!
      # final_time = text_to_milliseconds(final_time)
      
      effort_obj = {
        :rank => rank,# rank given to the time of the swimmer
        :name =>row.css('td:nth-child(2)').text.strip!,# name (first, last) of the swimmer
        :age => age,# age of the swimmer
        :team =>row.css('td:nth-child(4)').text.strip!,# swimmer's swim team
        :final_time =>final_time,# the swimmer's time for the event
        :standard =>row.css('td:nth-child(6)').text.strip! # category of the effort        
      }     
      efforts << effort_obj
    end
    efforts
  end
end