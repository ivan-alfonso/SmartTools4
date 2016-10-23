json.extract! user, :id, :name, :last_name, :email, :password_salt, :password_hash, :created_at, :updated_at
json.url user_url(user, format: :json)