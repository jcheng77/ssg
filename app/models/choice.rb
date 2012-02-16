class Choice
  MARK_BYTE = 6
  
  include Mongoid::Document
  include ObjectIdHelper
  include VisibleToHelper

  after_initialize do |o|
    o.mark_id! # mark the _id with the mark byte
  end
  
  TYPE_LIKE=:LIK
  TYPE_WISH=:WSH
  TYPE_RECOMMEND=:RCM

  # like: user likes this item, and only shows this like to visible_to list
  # wishlist: user wants to have this item, and only shows this wish to visible_to list
  # recommendation: user recommends this item to people in visible_to list

  field :object_id, type: BSON::ObjectId # the object that this choice is about, might be share/item/seller
  field :comment, type: String # sharing comment
  field :type, type: String # TYPE_LIKE=like/TYPE_WISH=wish/TYPE_RECOMMEND=recommend
  field :tags, type: Array # tags
  field :visible_to, type: Array # userid[], 

  index :object_id
  
  belongs_to :user, index: true
  
  # object
  def object
    find_object self.object_id
  end
end
