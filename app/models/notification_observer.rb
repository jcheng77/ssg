class NotificationObserver < Mongoid::Observer
  observe :share, :wish, :bag, :comment

  def after_create(object)
    if object.is_a? Share || object.is_a?(Wish) || object.is_a?(Bag)
      item = object.item
      item.followers_by_type(User.name).each do |user|
        if user._id != object.user_id
          Notification.create sender_id: object.user_id, receiver_id: user._id, type: Notification::TYPE_SHARE, target_id: object._id
        end
      end
    elsif object.is_a? Comment
      unless object.is_root?
        root_object = object.root
        if root_object.is_a?(Share) || root_object.is_a?(Wish) || root_object.is_a?(Bag)
          root_object.followers_by_type(User.name).each do |user|
            if user._id != object.user_id
              Notification.create sender_id: object.user_id, receiver_id: user._id, type: Notification::TYPE_COMMENT, target_id: object._id
            end
          end
        end
      end
    end
  end
end