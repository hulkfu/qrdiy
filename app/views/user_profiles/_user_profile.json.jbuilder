json.extract! user_profile, :id, :name, :avatar, :homepage, :location, :gender, :birthday, :description, :user_id, :created_at, :updated_at
json.url user_profile_url(user_profile, format: :json)