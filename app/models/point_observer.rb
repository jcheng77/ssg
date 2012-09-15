class PointObserver < Mongoid::Observer
  observe :share

  def after_create(object)
    case object.share_type
      when Share::TYPE_SHARE
        object.user.inc(:point, 1)
        root_share = object.item.root_share
        unless root_share.nil?
          root_share.user.inc(:point, 5) if root_share._id != object._id
        end
      when Share::TYPE_WISH, Share::TYPE_BAG
        root_share = object.item.root_share
        if root_share.blank?
          object.user.inc(:point, 5)
        else
          object.user.inc(:point, 1)
          root_share.user.inc(:point, 5)
        end
    end
  end
end