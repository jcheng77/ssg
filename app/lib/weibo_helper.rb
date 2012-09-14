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


  def monitor_mention

      mentions = client.statuses.mentions
      text = mentions["statuses"].first.text
      t_hash = text.split(' ')
      url = t_hash.select {|x| /http:\/\/t.cn.*/.match(x) }
      cmt = t_hash.select {|a| !a.index('boluome')}.join(" ")
      url.pop
      url << 'http://item.taobao.com/item.htm?id=15203028631&ali_trackid=2:mm_30329713_0_0:1347637282_4k5_183895383&spm=2014.12483819.1.0'
      col = Collector.new(url.first) if url
      item = Item.first(conditions: { _id: col.item_id })

      if item.nil?
      #item = Item.new_with_collector(col)
      binding.pry
      item = Item.create(
      source_id: col.item_id,
      title: col.title,
      image: col.imgs.first,
      purchase_url: col.purchase_url,
      category: '数码'
    )
      sharer = User.first
      share = Share.new(
      source: col.item_id,
      price: col.price,
      user_id: sharer._id,
      item_id: item._id
      )
      share.save
      share.create_comment_by_sharer(cmt)
      item.update_attribute(:root_share_id, share._id)
      sharer.follow item
      sharer.follow share.comment
      sharer.followers_by_type(User.name).each { |user| user.follow @share }

      end
  end

end

