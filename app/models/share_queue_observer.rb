class ShareQueueObserver< Mongoid::Observer
  observe :share_queue

  def after_create(object)
    WeiboHelper.create_item_share_by_weibo
  end

end

