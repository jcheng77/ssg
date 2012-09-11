class NotificationObserver < Mongoid::Observer
  observe :share, :wish, :bag, :comment

  def after_create(object)
    type = nil, followed_object = nil
    if object.is_a?(Share)
      followed_object = object.user
      type = Notification::TYPE_SHARE
    elsif object.is_a?(Wish)
      followed_object = object.user
      type = Notification::TYPE_WISH
    elsif object.is_a?(Bag)
      followed_object = object.user
      type = Notification::TYPE_BAG
    elsif object.is_a? Comment
      unless object.is_root_comment?
        followed_object = object.root
        if followed_object.is_a?(Share) || followed_object.is_a?(Wish) || followed_object.is_a?(Bag)
          type = Notification::TYPE_COMMENT
          followed_object = followed_object.comment
        end
      end
    end
    if type != nil && followed_object != nil
      followed_object.followers_by_type(User.name).each do |user|
        if user._id != object.user_id
          Notification.create sender_id: object.user_id, receiver_id: user._id, type: type, target_id: object._id
        end
      end
    end
  end
end