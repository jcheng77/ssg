class NotificationObserver < Mongoid::Observer
  observe :share, :wish, :bag, :comment

  def after_create(object)
    type = nil, target_object = nil
    if object.is_a?(Share)
      target_object = object.item
      type = Notification::TYPE_SHARE
    elsif object.is_a?(Wish)
      target_object = object.item
      type = Notification::TYPE_WISH
    elsif object.is_a?(Bag)
      target_object = object.item
      type = Notification::TYPE_BAG
    elsif object.is_a? Comment
      unless object.is_root_comment?
        target_object = object.root
        if target_object.is_a?(Share) || target_object.is_a?(Wish) || target_object.is_a?(Bag)
          type = Notification::TYPE_COMMENT
        end
      end
    end
    if type != nil && target_object != nil
      target_object.followers_by_type(User.name).each do |user|
        if user._id != object.user_id
          Notification.create sender_id: object.user_id, receiver_id: user._id, type: type, target_id: object._id
        end
      end
    end
  end
end