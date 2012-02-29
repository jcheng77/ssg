class Comment
  MARK_BYTE = 5

  include Mongoid::Document
  include ObjectIdHelper

  after_initialize do |o|
    o.mark_id! # mark the _id with the mark byte
  end  

  # comment to share, object_id=share_id
  # comment to item, object_id=item_id (not now)
  # comment to seller, object_id=seller_id (not now)
  # comment to comment would be using weibo style, which is @user_nick_name, won't use object_id to refer to the target-comment id
  
  field :object_id_type, type: BSON::ObjectId # user make comment to item/seller/share etc.
  field :user_id, type: BSON::ObjectId # user who writes this comment
  field :comment, type: String # sharing comment

  index :object_id_type
  
  # user
  def user
    User.find(self.user_id)
  end
  
  # object
  def object
    find_object self.object_id_type
  end
end
