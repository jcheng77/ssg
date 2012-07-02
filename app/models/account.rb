class Account
  include Mongoid::Document

  field :aid, type: String # account id from 3rd party, e.g. weibo:13123, tb:xxx, tmall:xxxx, qq:xxx
  field :name, type:String
  field :access_token, type: String # authorization key
  field :token_secret, type: String # authorization key
  field :session_key, type: String
  field :active, type: Boolean # false=no, true=yes

  embedded_in :user
end
