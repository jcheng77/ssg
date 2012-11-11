class Account
  include Mongoid::Document

  field :type, type: String
  field :aid, type: String # account id from 3rd party, e.g. weibo:13123, tb:xxx, tmall:xxxx, qq:xxx
  field :nick_name, type:String
  field :access_token, type: String # authorization key
  field :token_secret, type: String # authorization key
  field :session_key, type: String
  field :active, type: Boolean # false=no, true=yes
  field :friends, type:Array
  field :fname, as: :friends_names, type:Array
  field :profile_url, type: String
  field :fimgs, as: :friends_profile_urls, type:Array

  embedded_in :user


  def full_profile_url
    if self.profile_url.nil?
    '#'
    elsif self.type == 'sina'
       'http://weibo.com/' + self.profile_url
    elsif self.type == 'qq'
       'http://t.qq.com/' + self.profile_url
    end
  end
 
end
