# encoding: utf-8

class Share
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongo::Followable::Followed
  include VisibleToHelper
  include CommentableHelper
  include TaggableHelper

  TYPE_SHARE = 'SHA'
  TYPE_BAG = 'BAG'
  TYPE_WISH = 'WIS'

  VISIBLE_TO_SELF = 'P'

  WISH_TAGS = ["生日礼物", "情人节", "光棍节", "圣诞礼物", "新年礼物","婚礼礼品", "节日礼品", "想送就送"]

  field :source, type: String # source id of the item, e.g. tb:13123, jd:131, vancl:323
  field :price, type: Float # price when user purchase the item
  field :product_rating, type: Integer # 1-5
  field :service_rating, type: Integer # 1-5
  field :images, type: Array # string[], url of images
  field :visibility, type: Array # when it's private, visibility=PRIVATE; when it's a public collection, visibility=nil; it also can be a group name that user set up
  field :anonymous, type: Boolean # false: named; true: anounymous
  field :verified, type: Boolean # has this purchase been verified? false:no, true:yes
  field :parent_share_id, type: BSON::ObjectId, default: nil
  field :share_type, type: String, default: TYPE_SHARE
  field :last_inform_price, type: Float
  field :subscribed, type: Boolean

  after_save :update_item_rating

  acts_as_commentable
  belongs_to :item, index: true
  belongs_to :user, index: true
  belongs_to :seller, index: true


  scope :by_type, lambda { |type| where(share_type: type) }
  scope :recent_by_type, lambda { |type| by_type(type).desc(:created_at) }
  scope :only_public, (where(visibility: nil))
  scope :show_private, (where(visibility: VISIBLE_TO_SELF))

  def self.init_params(user, item, collector)
    {
      source: collector.item_id,
      price: collector.price,
      user_id: user._id,
      item_id: item._id
    }
  end

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
    return if share_price <= new_price
    Rails.logger.info  [user._id , self.item._id, share_price, new_price].join('|').to_s
    Notification.create(sender_id: user._id, receiver_id: user._id, type: Notification::TYPE_MARKDOWN, target_id: _id)
    update_attributes(last_inform_price: new_price)
    WeiboQueue.create(share_id: _id)
  end

  def sync_to_weibo(sns_type_arr,client)
    if sns_type_arr.is_a?(Array)
      sns_type_arr.each do |sns| 
        self.user.update_weibo_status(sns,client,['我在菠萝蜜添加了一个心愿: ', self.comment.content, self.item.purchase_url, '(分享自@菠萝点蜜 boluo.me)'].join('  ') ,self.item.image)
      end
    else
      self.user.update_weibo_status(sns_type_arr,client,['我在菠萝蜜添加了一个心愿: ', self.comment.content, self.item.purchase_url,'(分享自@菠萝点蜜 boluo.me)' ].join('  ') ,self.item.image)
    end
  end

  def update_item_rating
    item.delay.update_rating
  end

  def dummy_comment
    '某个蜜友私藏了这个愿望'
  end

  def is_public?
    visibility.nil? || !(visibility.first == VISIBLE_TO_SELF)
  end
end
