class Notification
  include Mongoid::Document
  include ObjectIdHelper

  TYPE_FOLLOW=:FLW
  TYPE_ACTIVATE=:ACT
  TYPE_SHARE=:SHR
  TYPE_COMMENT=:CMT
  TYPE_AT_SHARE=:ATS
  TYPE_AT_COMMENT=:ATC
  
  # user A followed user B, :object_id_type=A, sender=A, :receiver=B, type=TYPE_FOLLOW
  # user A followed user B, but user B was inactive, now B is activated :object_id_type=B, sender=B, :receiver=A, type=TYPE_ACTIVATE
  # user A shared something with user B, :object_id_type=share_id, sender=A, :receiver=B, type=TYPE_SHARE
  # user A commented user B's share, :object_id_type=comment_id, sender=A, :receiver=B, type=TYPE_COMMENT
  # user A @ user B in A's share, :object_id_type=share_id, sender=A, :receiver=B, type=TYPE_AT_SHARE
  # user A @ user B in A's comment, :object_id_type=comment_id, sender=A, :receiver=B, type=TYPE_AT_COMMENT

  field :object_id_type, type: BSON::ObjectId # item_id/share_id/comment_id/recommend_id of this notification
  field :sender_id, type: BSON::ObjectId # notification from who
  field :receiver_id, type: BSON::ObjectId # notification to whom
  field :type, type:String # e.g. share with me/comment to my share or comment/at/followed me/recommended to me
  field :checked, type:Boolean # if this notification has been checked

  index :object_id_type
  index :receiver_id
  
  def object
    find_object(object_id_type);
  end
  
  def sender
    find_object(sender_id);
  end
  
  def receiver
    find_object(receiver_id);
  end
  
  def to_s
    case(type.to_sym)
      when TYPE_FOLLOW then return "user #{sender.full_name} followed you"
      when TYPE_ACTIVATE then return "#{sender.full_name} is activated"
      when TYPE_SHARE then return "user #{sender.full_name} shared #{object.item.title} with you"
      when TYPE_COMMENT then return "user #{sender.full_name} commented your share"
      when TYPE_AT_SHARE then return "user #{sender.full_name} @ you in his/her share"
      when TYPE_AT_COMMENT then return "user #{sender.full_name} @ you in his/her comment"
      else "Invalid Notification Type#{type}"
    end
  end
  
  def self.add(object_id_type, sender_id, receiver_id, type)
    if !Notification.first(conditions: {object_id_type: object_id_type, sender_id: sender_id, receiver_id: receiver_id})
      object_id_type = BSON::ObjectId(object_id_type.to_s) unless !object_id_type.is_a? BSON::ObjectId
      sender_id = BSON::ObjectId(sender_id.to_s) unless !sender_id.is_a? BSON::ObjectId
      receiver_id = BSON::ObjectId(receiver_id.to_s) unless !receiver_id.is_a? BSON::ObjectId
      Notification.new(object_id_type: object_id_type, sender_id: sender_id, receiver_id: receiver_id, type: type).save
    end
  end
end
