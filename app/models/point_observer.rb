class PointObserver < Mongoid::Observer
  observe :share, :wish

  def after_create(object)
    if object.is_a? Share
      object.user.inc(:point, 1)
      root_share = object.item.root_share
      unless root_share.nil?
        root_share.user.inc(:point, 5) if root_share._id != object._id
      end
    elsif object.is_a? Wish
      object.user.inc(:point, 1)
      object.item.root_share.user.inc(:point, 5)
    end
  end
end