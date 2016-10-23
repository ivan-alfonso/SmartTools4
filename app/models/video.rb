class Video
  
  include Dynamoid::Document

  table :name => :videos, :key => :id, :read_capacity => 5, :write_capacity => 5  

  field :name_autor
  field :last_name_autor
  field :email_autor
  field :comment
  field :state, :string, {default: 'En proceso'}
  field :url_converted_video
  field :video_original_filename
  field :video_content_type  

  attr_accessor :video_file

  validates :comment, presence: true
  validates :name_autor, presence: true
  validates :last_name_autor, presence: true
  validates :email_autor, presence: true
  validates_format_of :email_autor, :with => /@/

  belongs_to :competition

end
