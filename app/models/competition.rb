class Competition 

	include Dynamoid::Document

    table :name => :competitions, :key => :id, :read_capacity => 5, :write_capacity => 5	

	field :name
	field :prize
	field :dateStart, :datetime
	field :dateEnd, :datetime
	field :user_id
#	field :image_original_filename
#	field :image_content_type
	
 #   attr_accessor :image_file
	
	validates :name, presence: true
	validates :prize, presence: true

	has_many :videos,  dependent: :destroy 

end
