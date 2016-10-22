json.extract! competition, :id, :name, :url, :dateStart, :dateEnd, :prize, :created_at, :updated_at
json.url competition_url(competition, format: :json)