class Competition 

	include Dynamoid::Document

    table :name => :competitions, :key => :id, :read_capacity => 5, :write_capacity => 5	

	field :name
	field :prize
	field :url
	field :dateStart, :datetime
	field :dateEnd, :datetime

	#belongs_to :user
	#has_many :videos,  dependent: :destroy 

	validates :name, presence: true

	#has_attached_file :image,
	#				:path => "images/:id/:basename.:extension"
  	#validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

end
