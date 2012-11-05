# encoding: utf-8
class WeiboQueue
  include Mongoid::Document

  field :sid, as: :share_id, type: BSON::ObjectId
  field :n, as: :notified, type: String

  def self.target_hash
    weibo_hash = {}
    target_users = []
    prices = []
    all.each do |queue|
      begin
      cshare = queue.share
      user = queue.target_user
      rescue
        queue.destroy
        queue.save
        break
      end
      unless (user.accounts.sina.nil? && queue.price_difference.include?(nil))
      if target_users.include? user
        unless weibo_hash[user.accounts.first.nick_name].include?(queue.price_difference)
        weibo_hash[user.accounts.first.nick_name] << queue.price_difference
        end
        else
        target_users << user
        weibo_hash[user.accounts.first.nick_name] = (weibo_hash[user.accounts.first.nick_name] || []) << queue.price_difference
      end
      end
      end
    weibo_hash
  end

  def target_user
    Share.find(sid).user
  end

  def share
    Share.find(sid)
  end

  def price_difference
    [share.price, share.last_inform_price]
  end

  def self.notify_weibo_user
    u = User.find_official_weibo_account
    msgs = []
    wb = Weibo.new(u.accounts.first.type)
    wb.load_from_db(u.accounts.first.access_token, u.accounts.first.token_secret, u.accounts.first.expires_at)
    weibo_hash = target_hash
    weibo_hash.each do |user,prices|
     msg_head = ['@',user,'  亲 你收藏的',prices.size,'件商品的价格今天发生了变化'].join()
     msg_body = []
     prices.each do |p|
       msg_body << [' [价格从', p[0],'降到了',p[1],'] '].join()
     end
     msg_end = ' #菠萝蜜降价通知#'
      msgs << [msg_head,msg_body.flatten,msg_end].join()
    end
    wb.add_status(msgs)
  end

end
