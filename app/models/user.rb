class User 

	include Dynamoid::Document

    table :name => :users, :key => :id, :read_capacity => 5, :write_capacity => 5	

	field :name
	field :last_name
	field :email
	field :password_salt
	field :password_hash

    attr_accessor :password
    validates_confirmation_of :password
   	validates :name, presence: true
	validates :last_name, presence: true
	validates :email, presence: true
	validates_format_of :email, :with => /@/

    before_save :encrypt_password
    
	def encrypt_password
		self.password_salt = BCrypt::Engine.generate_salt
		self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)		
	end

	def self.authenticate(email, password)
		user = User.where(email: email).first
		if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
			user
		else
			nil
		end		
	end

end
