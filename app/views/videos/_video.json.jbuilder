json.extract! video, :id, :competition_id, :nameAutor, :lastNameAutor, :email, :comment, :state, :pathVideoConverted
json.url video_url(video, format: :json)