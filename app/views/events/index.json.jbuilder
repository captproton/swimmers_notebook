json.array!(@events) do |event|
  json.extract! event, :id, :title, :swim_meet_id, :results_url, :raw_text, :json_data
  json.url event_url(event, format: :json)
end
