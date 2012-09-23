class ShareQueue
  include Mongoid::Document
  include BookmarkletHelper

  field :ws, as: :weibo_source, type:String
  field :uid, as: :weibo_uid, type:String
  field :cmt, as: :share_comment, type:String
  field :url, as: :item_url, type:String
  field :wid, as: :weibo_status_id, type: String
  field :sid, as: :share_id, type: BSON::ObjectId

  validates_uniqueness_of :wid
  validates_presence_of :uid, :cmt, :url, :wid

  def create_share
    return unless user = User.find_by_weibo_uid(uid)
    collector = Collector.new(url)
    return unless collector.correct?

    # 先找是否有人分享过同样的item，如果有的话，update，没有就创建一个
    item = Item.update_or_create_by_collector(collector)

    # 如果share为nil，创建一个share，否则更新它
    share = Share.first(conditions: {item_id: item._id, user_id: user._id})
    share_params = Share.init_params(user, item, collector)
    if share.nil?
      share = Share.create(share_params)
    else
      share.update_attributes(share_params)
    end
  end
end
