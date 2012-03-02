class User
  MARK_BYTE = 1 # see ObjectIdHelper.mark_id

  include Mongoid::Document
  include ObjectIdHelper
  
  #devise :registerable, :database_authenticatable, :recoverable
  
  after_initialize do |o|
    o.mark_id! # mark the _id with the mark byte
  end  


  field :full_name, type: String # 
  field :nick_name, type: String # 
  field :userid, type: String
  field :email, type: String
  field :password, type: String
  field :password_salt, type: String
  field :avatar, type: String #  

  field :gender, type: Integer # 0 female/1 male/gay/lesbian/bisexual etc.
  field :dob, type: Date # date actually
  field :preference, type: Array # predefined tags used to filter item list
  field :tags, type: Array # system generated tags for this user, according to his/her share/like
  field :access_token, type: String
  field :token_secret, type: String



  email_regexp = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
  
  # relations
  embeds_many :accounts # second accounts

  has_many :shares
  has_many :choices

  # index  
  index :nick_name, unique: true
  
  # validation
  validates_uniqueness_of :nick_name
  validates_format_of :email, :with => email_regexp, :on => :update
 
  before_save :encrypt_password


  #------------------------------------
  # my notifications
  def notifications
    Notification.where(receiver_id: self._id)
  end

  # my likes
  def likes
    Choice.where(user_id: self._id, type: Choice::TYPE_LIKE)
  end

  # my wishes
  def wishes
    Choice.where(user_id: self._id, type: Choice::TYPE_WISH)
  end

  # my recommendations
  def recommends
    Choice.where(user_id: self._id, type: Choice::TYPE_RECOMMEND)
  end
  
  # my firends shared with me
  def shared_with_me
    hash = Hash.new
    Notification.where(receiver_id: self._id, type: Notification::TYPE_SHARE).each do |n|
      share = Share.find(n.object_id)
      if share
        if hash.has_key? share.item
          hash[share.item] << share
        else
          hash[share.item] = [share]
        end
      end
    end
    
    return hash
  end

  # connections of my following
  def following
    ary = Array.new
    Follow.where(user_id: self._id).each do |f|
      ary << f.following_id
    end
    return ary
  end
  def following_users
    ary = Array.new
    following.each do |id|
      ary << User.find(id)
    end
    return ary
  end
  
  # connections of my follower
  def followed_by
    ary = Array.new
    Follow.where(following_id: self._id).each do |f|
      ary << f.user_id
    end
    return ary
  end
  def followed_by_users
    ary = Array.new
    followed_by.each do |id|
      ary << User.find(id)
    end
    return ary
  end
  
  # action: follow
  def follow(user_id)
    user_id = BSON::ObjectId(user_id.to_s) unless !user_id.is_a? BSON::ObjectId
    if self._id.to_s!=user_id && Follow.where(user_id: self._id, following_id: user_id).empty?
      Follow.new(user_id: self._id, following_id: user_id).save

      # send notification
      Notification.add(self._id, self._id, user_id, Notification::TYPE_FOLLOW)
    end
  end

  # action: unfollow
  def unfollow(user_id)
    user_id = BSON::ObjectId(user_id.to_s) unless !user_id.is_a? BSON::ObjectId
    Follow.where(user_id: self._id, following_id: user_id).delete_all
  end

  # action: following?
  def following?(user_id)
    user_id = BSON::ObjectId(user_id.to_s) unless !user_id.is_a? BSON::ObjectId
    return !Follow.where(user_id: self._id, following_id: user_id).empty?
  end
  
  # action: notify my follower about my share
  def notify_my_share(share)
    return if (share.visible_to==Share::VISIBLE_TO_SELF)
    
    if share.visible_to
      # share to people in visible to list
      receivers = share.visible_to
    else
      # share to all people follows me
      receivers = followed_by
    end
    
    receivers.each do |receiver_id|
      # send notification
      Notification.add(share._id, self._id, receiver_id, Notification::TYPE_SHARE)
    end
  end



  def self.authenticate(input,password)
   user ||= User.where(email:input).first
   user ||= User.where(nick_name:input).first
   
   if user && user.password == BCrypt::Engine.hash_secret(password,user.password_salt)
     user
   else
     logger.info "user not found"
   end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password = BCrypt::Engine.hash_secret(password,password_salt)
    end
  end


end
