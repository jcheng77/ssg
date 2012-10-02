# encoding: utf-8
class Notification
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  TYPE_FOLLOW = 'FLW'
  TYPE_ACTIVATE = 'ACT'
  TYPE_SHARE = 'SHR'
  TYPE_BAG = 'BAG'
  TYPE_WISH = 'WIS'
  TYPE_COMMENT = 'CMT'
  TYPE_AT_COMMENT = 'ATC'
  TYPE_MARKDOWN = 'MAD'

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

  def target_object
    case self.type
      when TYPE_FOLLOW
        self.receiver
      when TYPE_ACTIVATE
        nil
      when TYPE_SHARE, TYPE_BAG, TYPE_WISH, TYPE_MARKDOWN
        Share.find self.target_id
      when TYPE_COMMENT, TYPE_AT_COMMENT
        Comment.find self.target_id
      else
        nil
    end
  end

  def highlighted_object
    object = self.target_object
    case self.type
      when TYPE_SHARE
        object.comment
      else
        object
    end
  end

  def shown_url
    object = self.target_object
    case self.type
      when TYPE_COMMENT, TYPE_AT_COMMENT
        object.root
      when TYPE_WISH
        {:controller => "users", :action => "my_wishes", :id => self.sender}
      when TYPE_BAG
        {:controller => "users", :action => "my_bags", :id => self.sender}
      when TYPE_FOLLOW
        {:controller => "users", :action => "followers", :id => self.receiver}
      else
        object
    end
  end

  def to_s
    case self.type
      when TYPE_FOLLOW then
        return "<em>#{sender.nick_name}</em> 关注了你"
      when TYPE_ACTIVATE then
        return "#{sender.nick_name} is activated"
      when TYPE_SHARE then
        return "<em>#{sender.nick_name}</em> 有了新的推荐"
      when TYPE_BAG then
        return "<em>#{sender.nick_name}</em> 添加了新的已购宝贝"
      when TYPE_WISH then
        return "<em>#{sender.nick_name}</em> 许了新的愿望"
      when TYPE_COMMENT then
        if self.target_object.root.user._id == self.receiver_id
          return "<em>#{sender.nick_name}</em> 评论了你的推荐"
        else
          return "<em>#{sender.nick_name}</em> 回复了你的评论"
        end
      when TYPE_AT_COMMENT then
        return "<em>#{sender.nick_name}</em> 在评论中@了你"
      when TYPE_MARKDOWN then
        return "你有新的降价通知"
      else
        "Invalid Notification Type#{type}"
    end
  end

  def sender
    User.find(sender_id) if sender_id
  end

  def receiver
    User.find self.receiver_id
  end

  def set_checked
    self.update_attribute :checked, true
  end

  def self.recent_limit(user_id, num = 5)
    Notification.where(:checked => false, :receiver_id => user_id).desc(:created_at).limit(num)
  end

  def self.all_of_user(user_id, page, per_page = 10)
    Notification.where(:receiver_id => user_id).desc(:created_at).paginate(:page => page, :per_page => per_page)
  end

  def self.receiver_unchecked(user_id)
    Notification.where(:checked => false, :receiver_id => user_id)
  end
end
