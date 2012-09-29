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

    # TODO: Add to transaction
    item = Item.update_or_create_by_collector(collector)

    share = Share.first(conditions: {item_id: item._id, user_id: user._id})
    share_params = Share.init_params(user, item, collector)
    if share.nil?
      share = Share.create(share_params)
    else
      share.update_attributes(share_params)
    end
    share.create_comment_by_sharer(share_comment)

    item.update_attributes(root_share_id: share._id) if item.root_share.nil?

    update_attributes(sid: share.id)
  end
end
