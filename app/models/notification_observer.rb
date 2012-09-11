class NotificationObserver < Mongoid::Observer
  observe :share, :wish, :bag, :comment, :follow

  def after_create(object)
    type = nil
    notify_objects = []
    sender_id = nil

    if object.is_a?(Follow)
      return if (object.f_type != User.name || object.following_type != User.name)
      type = Notification::TYPE_FOLLOW
      sender_id = object.following_id
      notify_objects << User.find(object.f_id)
    elsif object.is_a?(Share)
      notify_objects = object.user.followers_by_type(User.name)
      type = Notification::TYPE_SHARE
      sender_id = object.user_id
    elsif object.is_a?(Wish)
      notify_objects = object.user.followers_by_type(User.name)
      type = Notification::TYPE_WISH
      sender_id = object.user_id
    elsif object.is_a?(Bag)
      notify_objects = object.user.followers_by_type(User.name)
      type = Notification::TYPE_BAG
      sender_id = object.user_id
    elsif object.is_a? Comment
      unless object.is_root_comment?
        target_object = object.root
        if target_object.is_a?(Share) || target_object.is_a?(Wish) || target_object.is_a?(Bag)
          notify_objects = target_object.comment.followers_by_type(User.name)
          type = Notification::TYPE_COMMENT
          sender_id = object.user_id
        end
      end
    end
    if type != nil
      notify_objects.each do |user|
        if user._id != sender_id
          Notification.create sender_id: sender_id, receiver_id: user._id, type: type, target_id: object._id
        end
      end
    end
  end
end