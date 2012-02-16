class Account
  include Mongoid::Document

  field :id, type: String # account id from 3rd party, e.g. weibo:13123, tb:xxx, tmall:xxxx, qq:xxx
  field :auth_key, type: String # authorization key
  field :verified, type: Boolean # false=no, true=yes

  embedded_in :user
end
