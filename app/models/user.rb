class User
  MARK_BYTE = 1 # see ObjectIdHelper.mark_id

  include Mongoid::Document
  include Mongo::Voter
  include Mongo::Follower
  include Mongo::Followable
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

  field :session_key, type: String



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
 
  before_save :encrypt_password, :save_fullname


  #------------------------------------
  # my notifications
  def notifications
    Notification.where(receiver_id: self._id)
  end
  
  # my firends shared with me
  def shared_with_me
    hash = Hash.new
    Notification.where(receiver_id: self._id, type: Notification::TYPE_SHARE).each do |n|
      share = Share.find(n.object_id_type)
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

  def save_fullname
    self.full_name ||= self.nick_name
  end

end
