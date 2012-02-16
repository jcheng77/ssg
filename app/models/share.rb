class Share
  MARK_BYTE = 3
  
  include Mongoid::Document
  include ObjectIdHelper
  include VisibleToHelper

  after_initialize do |o|
    o.mark_id! # mark the _id with the mark byte
  end  

  field :source, type: String # source id of the item, e.g. tb:13123, jd:131, vancl:323
  field :price, type: Float # price when user purchase the item
  field :product_rating, type: Integer # 1-5
  field :service_rating, type: Integer # 1-5
  field :images, type: Array # string[], url of images
  field :tags, type: Array # string[]
  field :comment, type: String # sharing comment
  field :visible_to, type: Array # when it's private, visibleTo=VISIBLE_TO_SELF; when no limit, visibleTo=nil
  field :anonymous, type: Boolean #false: named; true: anounymous
  field :verified, type: Boolean # has this purchase been verified? false:no, true:yes

  belongs_to :item, index: true
  belongs_to :user, index: true
  belongs_to :seller, index: true

  # comments
  def comments
    Comment.where(object_id: self._id)
  end
  
  # likes
  def likes
    Choice.where(object_id: self._id, type: Choice::TYPE_LIKE)
  end
  
  # wishes
  def wishes
    Choice.where(object_id: self._id, type: Choice::TYPE_WISH)
  end
  
  # recommends
  def recommends
    Choice.where(object_id: self._id, type: Choice::TYPE_RECOMMEND)
  end
end
