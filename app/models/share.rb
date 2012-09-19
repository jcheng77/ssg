# encoding: utf-8

class Share
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongo::Followable
  include VisibleToHelper
  include CommentableHelper
  include TaggableHelper

  TYPE_SHARE = 'SHA'
  TYPE_BAG = 'BAG'
  TYPE_WISH = 'WIS'

  WISH_TAGS = ["生日礼物", "同学聚会", "婚礼礼品"]

  field :source, type: String # source id of the item, e.g. tb:13123, jd:131, vancl:323
  field :price, type: Float # price when user purchase the item
  field :product_rating, type: Integer # 1-5
  field :service_rating, type: Integer # 1-5
  field :images, type: Array # string[], url of images
  field :visible_to, type: Array # when it's private, visibleTo=VISIBLE_TO_SELF; when no limit, visibleTo=nil
  field :anonymous, type: Boolean # false: named; true: anounymous
  field :verified, type: Boolean # has this purchase been verified? false:no, true:yes
  field :parent_share_id, type: BSON::ObjectId, default: nil
  field :share_type, type: String, default: TYPE_SHARE
  field :last_inform_price, type: Float
  field :subscribed, type: Boolean

  acts_as_commentable
  belongs_to :item, index: true
  belongs_to :user, index: true
  belongs_to :seller, index: true

  validates_presence_of :price

  scope :by_type, lambda { |type| where(share_type: type) }
  scope :recent_by_type, lambda { |type| by_type(type).desc(:created_at) }

  def copy_attributes(attributes = {})
    {:source => self.source,
     :price => self.price,
     :parent_share_id => self._id,
     :item_id => self.item.id
    }.merge(attributes)
  end

  def root_share
    parent_share = self.parent_share
    parent_share.nil? ? self : parent_share.root_share
  end

  def is_root_share?
    self.parent_share.nil?
  end

  def parent_share
    self.parent_share_id.nil? ? nil : Share.find(self.parent_share_id)
  end

  def create_comment_by_sharer(content)
    self.create_comment(user_id: self.user_id, content: content)
  end

  def items_with_any_same_tags
    Item.tagged_with_any(self.item.tags_array)
  end

  def markdown_inform(new_price)
    share_price = last_inform_price || price
    return if share_price < new_price
    # TODO: Send notification to user
    update_attributes(last_inform_price: new_price)
  end
end
