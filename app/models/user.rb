class User < ActiveRecord::Base
    has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
    validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  
    before_create :create_remember_token
    has_secure_password
    has_many :posts
    has_many :relationships, foreign_key: "follower_id", dependent: :destroy
    has_many :followeds, through: :relationships
    has_many :reverse_relationships, foreign_key: "followed_id", dependent: :destroy, 
            class_name: "Relationship"
    has_many :followers, through: :reverse_relationships, source: :follower
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    
    validates :login, presence: true, uniqueness: true, length: {minimum: 3, maximum: 12}
    validates :email, presence: true, uniqueness: {case_sensitive: false}, format: VALID_EMAIL_REGEX
    validates :password, length: {minimum: 6}
    
    def User.new_remember_token
        SecureRandom.urlsafe_base64
    end
    def User.encrypt(token)
        Digest::SHA1.hexdigest(token.to_s)
    end
    
    def follow(user)
        self.relationships.create(followed_id: user)
    end

    def unfollow(user)
        self.relationships.find_by_followed_id(user).destroy if following?(user)
    end

    def following?(user)
        self.relationships.find_by_followed_id(user)
    end

    def feed
        Post.where(user_id: followed_user_ids)
    end
    
    private
        def create_remember_token
            self.remember_token = User.encrypt(User.new_remember_token)
        end
    
    before_save {self.email = email.downcase}

end
