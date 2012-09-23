class ShareQueueObserver< Mongoid::Observer
  observe :share_queue

  def after_create(object)
    object.delay.create_share
  end
end

