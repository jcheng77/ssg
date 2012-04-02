class Notification
  include Mongoid::Document

  TYPE_FOLLOW = 'FLW'
  TYPE_ACTIVATE = 'ACT'
  TYPE_SHARE = 'SHR'
  TYPE_COMMENT = 'CMT'
  TYPE_AT_SHARE = 'ATS'
  TYPE_AT_COMMENT = 'ATC'

  # user A followed user B, :object_id = A, sender = A, :receiver = B, type = TYPE_FOLLOW
  # user A followed user B, but user B was inactive, now B is activated :object_id = B, sender = B, :receiver = A, type = TYPE_ACTIVATE
  # user A shared something with user B, :object_id = share_id, sender = A, :receiver = B, type = TYPE_SHARE
  # user A commented user B's share, :object_id = comment_id, sender = A, :receiver = B, type = TYPE_COMMENT
  # user A @ user B in A's share, :object_id = share_id, sender = A, :receiver = B, type = TYPE_AT_SHARE
  # user A @ user B in A's comment, :object_id = comment_id, sender = A, :receiver = B, type = TYPE_AT_COMMENT

  field :target_id, type: BSON::ObjectId # item_id/share_id/comment_id/recommend_id of this notification
  field :sender_id, type: BSON::ObjectId # notification from who
  field :receiver_id, type: BSON::ObjectId # notification to whom
  field :type, type: String # e.g. share with me/comment to my share or comment/at/followed me/recommended to me
  field :checked, type: Boolean, default: false # if this notification has been checked

  def object
    case self.type
      when TYPE_FOLLOW
        nil
      when TYPE_ACTIVATE
        nil
      when TYPE_SHARE
        Share.find self.target_id
      when TYPE_COMMENT
        Comment.find self.target_id
      when TYPE_AT_SHARE
        Share.find self.target_id
      when TYPE_AT_COMMENT
        Comment.find self.target_id
      else
        nil
    end
  end

  def sender
    User.find self.sender_id
  end

  def receiver
    User.find self.receiver_id
  end

  def to_s
    case self.type
      when TYPE_FOLLOW then
        return "user #{sender.full_name} followed you"
      when TYPE_ACTIVATE then
        return "#{sender.full_name} is activated"
      when TYPE_SHARE then
        return "user #{sender.full_name} shared #{object.item.title} with you"
      when TYPE_COMMENT then
        return "user #{sender.full_name} commented your share"
      when TYPE_AT_SHARE then
        return "user #{sender.full_name} @ you in his/her share"
      when TYPE_AT_COMMENT then
        return "user #{sender.full_name} @ you in his/her comment"
      else
        "Invalid Notification Type#{type}"
    end
  end
end
