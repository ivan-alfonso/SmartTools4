class Video
  
  include Dynamoid::Document

  table :name => :videos, :key => :id, :read_capacity => 5, :write_capacity => 5  

  field :nameAutor
  field :lastNameAutor
  field :email
  field :comment
  field :state, :string, {default: 'En proceso'}
  field :pathVideoConverted


  validates :comment, presence: true
  #validates :videoOriginal, attachment_presence: true
  #validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  belongs_to :competition


  #has_attached_file :videoOriginal,
  #        :path => "original-videos/:id/:basename.:extension",
  #        :processors => lambda { |a| a.is_video? ? [ :ffmpeg ] : [ :thumbnail ] }
  #validates_attachment_content_type :videoOriginal, content_type: /\Avideo\/.*\Z/ 
end
