# encoding: utf-8
class User
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  include Mongo::Voter
  include Mongo::Followable::Followed
  include Mongo::Followable::Follower
  include WeiboHelper

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

  EMAIL_REGEXP = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i

  # relations
  embeds_many :accounts do # second accounts
    def sina
      @target.select { |account| account.type == 'sina'}.first
    end
    def qq 
      @target.select { |account| account.type == 'qq'}.first
    end
  end

  accepts_nested_attributes_for :accounts
  has_many :shares
  has_many :choices

  # index
  index :nick_name, unique: true , :message => "用户名已存在"

  # validation
  validates_uniqueness_of :nick_name
  validates_format_of :email, :with => EMAIL_REGEXP , :message => "邮箱格式不正确"

  before_save :encrypt_password

  def self.find_if_exists(conditions)
    self.where(conditions).exists? ? self.where(conditions).first : nil
  end

  def has_shared?(type, item)
    self.shares.where(:share_type => type, :item_id => item._id).exists?
  end

  def followed_all(page, per_page = 8)
    Share.followees_of(self).reverse.paginate(:page => page, :per_page => per_page)
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

  def cycle_shares(page, per_page = 8)
    cycle_friends = []
    self.followees_by_type(User.name).each do |f|
      f.followees_by_type(User.name).each { |ff| cycle_friends << ff._id }
    end
    cycle_friends.uniq!
    cycle_friends.delete self._id
    Share.where(:user_id.in => cycle_friends).paginate(:page => page, :per_page => per_page)
  end

  def recent_shares(limit = 8)
    self.shares.where(share_type: Share::TYPE_SHARE).desc(:created_at).limit(limit)
  end

  def recent_bags(limit = 8)
    self.shares.where(share_type: Share::TYPE_BAG).desc(:created_at).limit(limit)
  end

  def recent_wishes(limit = 8)
    self.shares.where(share_type: Share::TYPE_WISH).desc(:created_at).limit(limit)
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

  def self.find_by_weibo_uid(weibo_uid)
    target_user = nil
    all.each do |user|
      accounts = user.accounts.where(type: 'sina', aid: weibo_uid)
      target_user = user if accounts.present?
    end
    return target_user
  end

  def self.find_official_weibo_account
    #find_by_weibo_uid('2884474434')
    find_by_weibo_uid('3023348901')
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

  def is_official_weibo_account?
    self.accounts.sina && self.accounts.sina.aid == '3023348901' 
  end

  def update_weibo_status(sns_type,client,text,pic)
    case sns_type
    when 'sina'
    client.statuses.upload_url_text({:status => text,:url => pic} )
  when 'qq'
   client.upload_image_url(text,pic) 
  end
  end

  def self.create_user_account_with_weibo_hash(type,userinfo,access_token,token_secret,friends_ids = nil, friends_names = nil, expires_at = nil)
    aid = userinfo.delete("id")
    profile_url = userinfo.delete("profile_url")
    cur_user = User.new(userinfo)
    cur_user.accounts.build( :type => type, :aid => aid, :nick_name => userinfo["name"] , :access_token => access_token, :token_secret => token_secret , :avatar => userinfo["profile_image_url"] , :profile_url => profile_url , :friends => friends_ids , :friends_names => friends_names, :expires_at => expires_at)
    return cur_user
  end

  def refresh_official_weibo_mention
    if is_official_weibo_account?
      wb = Weibo.new(self.accounts.first.type)
      wb.init_client
      wb.load_from_db(self.accounts.first.access_token, self.accounts.first.token_secret, self.accounts.first.expires_at)
      @mentions = wb.fetch_latest_mentions
      process_weibo_mentions(@mentions)
    end
  end

  def self.monitoring_official_weibo_mention
    u = self.find_official_weibo_account
    u.refresh_official_weibo_mention
  end


end
