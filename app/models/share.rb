class Share
  MARK_BYTE = 3

  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongo::Followable
  include ObjectIdHelper
  include VisibleToHelper
  include CommentableHelper
  include TaggableHelper

  after_initialize do |o|
    o.mark_id! # mark the _id with the mark byte
  end

  field :source, type: String # source id of the item, e.g. tb:13123, jd:131, vancl:323
  field :price, type: Float # price when user purchase the item
  field :product_rating, type: Integer # 1-5
  field :service_rating, type: Integer # 1-5
  field :images, type: Array # string[], url of images
  field :visible_to, type: Array # when it's private, visibleTo=VISIBLE_TO_SELF; when no limit, visibleTo=nil
  field :anonymous, type: Boolean # false: named; true: anounymous
  field :verified, type: Boolean # has this purchase been verified? false:no, true:yes

  acts_as_taggable
  acts_as_commentable
  belongs_to :item, index: true
  belongs_to :user, index: true
  belongs_to :seller, index: true

  def comment_content
    comment = self.comment
    comment.nil? ? nil : comment.content
  end

  def create_comment_by_sharer(content)
    self.create_comment(user_id: self.user_id, content: content)
  end

  def items_with_any_same_tags
    Item.tagged_with_any(self.item.tags_array)
  end
end
