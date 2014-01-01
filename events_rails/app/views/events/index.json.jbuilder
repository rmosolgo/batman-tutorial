json.array!(@events) do |event|
  json.extract! event, :id, :name, :starts_at, :ends_at, :venue_id
  json.url event_url(event, format: :json)
end
