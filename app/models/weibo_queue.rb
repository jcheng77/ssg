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
    [share.item.title.slice(0,24) , share.price, share.last_inform_price]
  end

  def self.notify_weibo_user
    u = User.find_official_weibo_account
    msgs = []
    wb = Weibo.new(u.accounts.first.type)
    wb.load_from_db(u.accounts.first.access_token, u.accounts.first.token_secret, u.accounts.first.expires_at)
    weibo_hash = target_hash
    weibo_hash.each do |user,prices|
     msg_head = ['@',user,'  亲 你收藏的',prices.size,'个愿望宝贝'].join()
     msg_body = []
     prices.each do |p|
       msg_body << [' [', p[0] ,'价格从', p[1],'降到了',p[2],'] '].join()
     end
     msg_end = '登录菠萝蜜查看 http://boluo.me/syncs/sina/new '
      msgs << [msg_head,msg_body.flatten,msg_end].join()
    end
	msgs.each do |m|
    	wb.add_status(m)
    	sleep(180)
	end
  end

end
