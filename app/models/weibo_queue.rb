class WeiboQueue
  include Mongoid::Document

  field :sid, as: :share_id, type: String
end
