json.extract! competition, :id, :name, :url, :dateStart, :dateEnd, :prize, :created_at, :updated_at, :user_id
json.url competition_url(competition, format: :json)