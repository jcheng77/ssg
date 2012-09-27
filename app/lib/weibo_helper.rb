#encoding: utf-8

include BookmarkletHelper

module WeiboHelper
  #extract id and name and profile image infomation from the json object returned from QQ weibo
  KEY_MAP = {"openid" => "id" , "name" => "name" , "head" => "profile_image_url", "location" => "location", "email" => "email" , "birth_day" => "birth_day", "birth_month" => "birth_month", "birth_year" => "birth_year", "birthday" => "birthday" , "profile_url" => "profile_url" , "homepage" => "profile_url"}

  def extract_user_info(hash)
    if hash.has_key?('data')
      hashdata = hash["data"]
      userhash = Hash[hashdata.map { |k,v| [ KEY_MAP[k], v ] }]
      #userhash = { "id" => hashdata["openid"], "name" => hashdata["name"] , "profile_image_url" => hashdata["head"], "location" => hashdata["location"], "email" => hashdata["email"] , "birthday" => "#{hashdata["birth_year"]}#{hashdata["birth_month"]}#{hashdata["birth_day"]}" , "description" => hashdata["description"] }
    else
      hash.select {|k,v| KEY_MAP.values.index(k) }
    end  
  end


  def process_weibo_mentions(mentions)
    unless mentions.nil?
      mentions["statuses"].each do |status|
        share_hash = weibo_parser(status)
        put_share_in_queue(share_hash)
        last_id = share_hash["weibo_status_id"] 
        if Status.exists?
          Status.update_all(last_since_id: last_id)
        else
          Status.create(last_since_id: last_id)
        end
      end
    end
  end
  #handle_asynchronously :process_weibo_mentions, :priority => 1 


  def create_item_share_by_weibo
    weibo_item = ShareQueue.asc(:weibo_status_id).first
    if weibo_item
      col = Collector.new(weibo_item.item_url)
      item = Item.first(conditions: { _id: col.item_id })

      if item.nil?
        item = Item.create(
          source_id: col.item_id,
          title: col.title,
          image: col.imgs.first,
          purchase_url: col.purchase_url,
          category: '数码'
        )
        account = nil
        User.all.each do |user|
          account = user.accounts.where(type: 'sina', aid: weibo_item.weibo_uid).first
        end until account
        if account
          sharer = account.user
          share = Share.new(
            source: col.item_id,
            price: col.price,
            user_id: sharer._id,
            item_id: item._id
          )
          share.save
          share.create_comment_by_sharer(weibo_item.share_comment)
          item.update_attribute(:root_share_id, share._id)
          sharer.follow item
          sharer.follow share.comment
          sharer.followers_by_type(User.name).each { |user| user.follow @share }
        end
      end
      weibo_item.destroy
    end
  end
  handle_asynchronously :create_item_share_by_weibo, :priority => 95


  def weibo_parser(weibo_status)
    t_id = weibo_status.id
    t_hash = weibo_status.text.split(' ')
    url = t_hash.select {|x| /http:\/\/t.cn.*/.match(x) }
    cmt = t_hash.select {|a| !a.index('boluome')}.join(" ")
    weibo_uid = weibo_status.user["idstr"]
    { :weibo_uid => weibo_uid, :share_comment => cmt ,:item_url => url.first , :weibo_status_id  =>  t_id }
  end

  def put_share_in_queue(hash)
    q = ShareQueue.create(hash)
    Status.create(:last_since_id => q.weibo_status_id) if q
  end


  def fetch_latest_mentions(client)
    if Status.exists?
      client.statuses.mentions(:since_id => Status.all.first.last_since_id) 
    else
      client.statuses.mentions
    end
  end


  def send_weibo_notification(client, msg)
    client.statuses.update(msg)
  end
end
