class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable
  
  field :name
  field :provider
  field :uid
  field :email
  field :nickname
  field :location
  field :image

  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :email, :provider, :uid
  attr_protected :provider, :uid, :name, :email

	def self.create_with_omniauth(auth)
	  create! do |user|
	  	user.provider = auth['provider']
	    user.uid = auth['uid']
	    if auth['info']
	    	user.name = auth['info']['name'] || ""
	      user.email = auth['info']['email'] || ""
        user.nickname = auth['info']['nickname'] || ""
        user.location = auth['info']['location'] || ""
        user.image = auth['info']['image'] || ""
	    end
	  end
	end

  def is_admin?
    ['simonech', 'jitidea', 'emadb'].include? nickname
  end

end
