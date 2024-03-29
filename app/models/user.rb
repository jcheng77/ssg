# encoding: utf-8

require 'set'

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

  field :preferences, type: Array, default: ["数码","创意礼品"]
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

  def self.search_by_nick_name(key_word)
    key_word.blank? ? [] : self.where(:nick_name => /.*(#{key_word}).*/)
  end

  def self.nick_names
    self.only(:nick_name).all.to_a.map { |u| u.nick_name }
  end

  def has_shared?(type, item)
    self.shares.where(:share_type => type, :item_id => item._id).exists?
  end

  def has_any_shares?
    self.shares.size > 0 
  end

  def followed_all(page, per_page = 8)
    Share.followees_of(self).reverse.paginate(:page => page, :per_page => per_page)
  end

  def has_followed_any?
    Share.followees_of(self).size > 0
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

  def all_my_shares(page, per_page=8)
    Share.where(:user_id => self._id).reverse.paginate(:page => page, :per_page => per_page)
  end

  def cycle_shares(page, per_page = 8)
    friends_id = Set[]
    secondary_friends_id = Set[]
    self.followees_by_type(User.name).each do |f|
      friends_id << f._id
      f.followees_by_type(User.name).each { |ff| secondary_friends_id << ff._id }
    end
    secondary_friends_id.delete self._id
    secondary_friends_id -= friends_id
    Share.where(:user_id.in => secondary_friends_id.to_a).reverse.paginate(:page => page, :per_page => per_page)
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
      if account && sns_account && sns_account.friends.to_a.include?(account.aid.to_s)
        friend_users << user
      end
    end
    following = followees_by_type(User.name)
    return friend_users - following
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

  def self.update_user_weibo(uid,sns_type,message,pic = nil)
    user = User.find(uid)
    wb = Weibo.new(sns_type)
    wb.load_from_db(user.accounts.first.access_token,user.accounts.first.token_secret,user.accounts.first.expires_at)
    wb.add_status(message,pic)
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

  def update_weibo_status_only_text(sns_type,client,text)
    case sns_type
    when 'sina'
    client.statuses.update(text)
    when 'qq'
    client.add_status(text) 
    end
  end

  def update_weibo_status_with_pic(sns_type,client,text,pic)
    case sns_type
    when 'sina'
    client.statuses.upload_url_text({:status => text.force_encoding('UTF-8'),:url => pic} )
  when 'qq'
   client.upload_image_url(text.force_encoding('UTF-8'),pic)
  end
  end

  def suggested_friends(sns_type)
    suggested_friends = self.known_sns_friends(sns_type)
    known_friends_count = suggested_friends.size
    if suggested_friends.size < 9
      suggested_friends << (User.all.limit(18- suggested_friends.size).to_a - suggested_friends - self.to_a)
      suggested_friends.flatten!
    end
    [suggested_friends[0..9], known_friends_count]
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
