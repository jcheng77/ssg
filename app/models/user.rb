class User
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  include Mongo::Voter
  include Mongo::Follower
  include Mongo::Followable

  #devise :registerable, :database_authenticatable, :recoverable

  field :nick_name, type: String #
  field :email, type: String
  field :password, type: String
  field :password_salt, type: String
  field :avatar, type: String

  field :gender, type: Integer # 0 female/1 male/gay/lesbian/bisexual etc.

  field :preferences, type: Array, default: []
  field :point, type: Integer, default: 0
  field :active, type: Integer, default: 0

  field :birthday, type: Date
  field :description, type: String
  field :city, type: String
  field :address, type: String

  email_regexp = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i

  # relations
  embeds_many :accounts do # second accounts
    def sina
      @target.select { |account| account.type == 'sina' }
    end

    def qq
      @target.select { |account| account.type == 'qq' }
    end

  end

  has_many :shares
  has_many :choices

  # index
  index :nick_name, unique: true

  # validation
  validates_uniqueness_of :nick_name
  validates_format_of :email, :with => email_regexp, :on => :update

  before_save :encrypt_password

  def followed_all(page, per_page = 8)
    Share.desc(:created_at).followees_of(self).paginate(:page => page, :per_page => per_page)
  end

  def my_shares(page, per_page = 8)
    self.shares.recent_by_type(Share::TYPE_SHARE).paginate(:page => page, :per_page => per_page)
  end

  def my_wishes(page, per_page = 8)
    self.shares.recent_by_type(Share::TYPE_WISH).paginate(:page => page, :per_page => per_page)
  end

  def my_bags(page, per_page = 8)
    self.shares.recent_by_type(Share::TYPE_BAG).paginate(:page => page, :per_page => per_page)
  end

  def recent_shares(limit = 6)
    self.shares.where(share_type: Share::TYPE_SHARE).desc(:created_at).limit(limit)
  end

  def recent_bags(limit = 10)
    self.shares.where(share_type: Share::TYPE_BAG).desc(:created_at).limit(limit)
  end

  def recent_wishes(limit = 10)
    self.shares.where(share_type: Share::TYPE_WISH).limit(limit)
  end

  # my notifications
  def notifications
    Notification.where(receiver_id: self._id)
  end

  def known_sns_friends(snstype)
    sns_account = self.accounts.where(type: snstype).first
    friend_users = []
    users = User.all
    users.each do |user|
      account = user.accounts.first
      if account && sns_account && account.friends.to_a.include?(sns_account.aid.to_i)
        friend_users << user
      end
    end
    return friend_users
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

  def self.authenticate(input, password)
    user ||= User.where(email :input).first
    user ||= User.where(nick_name :input).first

    if user && user.password == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      logger.info "user not found"
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def activate
    self.active = 1 if self.active == 0
  end

  def follow_my_own_share(share)
    if share
      follow share.comment
      follow share.item
    end
  end

  def push_new_share_to_my_follower(share)
    followers_by_type(User.name).each { |user| user.follow share }
  end
end
