class WeiboQueue
  include Mongoid::Document

  field :sid, as: :share_id, type: BSON::ObjectId

  def self.target_hash
    weibo_hash = {}
    target_users = []
    all.each do |queue|
      user = queue.target_user
      if target_users.include? user
        weibo_hash[user.name] += 1
      else
        target_users << user
        weibo_hash[user.name] = 1
      end
    end

    weibo_hash
  end

  def target_user
    Share.find(sid).user
  end
end
