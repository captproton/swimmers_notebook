json.array!(@swim_meets) do |swim_meet|
  json.extract! swim_meet, :id, :started_on, :finished_on, :courses, :location, :location, :results_url
  json.url swim_meet_url(swim_meet, format: :json)
end
