class ShareQueue
  include Mongoid::Document
  field :uid, as: :weibo_uid, type:String
  field :cmt, as: :share_comment, type:String
  field :url, as: :item_url, type:String
  field :wid, as: :weibo_status_id, type: String
  field :sid, as: :share_id, type: BSON::ObjectId

  validates_uniqueness_of :wid
end
