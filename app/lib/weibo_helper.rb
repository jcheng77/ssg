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
      client = session[:client]

      mentions = client.statuses.mentions
      text = mentions["statuses"].first.text
      t_hash = text.split(' ')
      url = t_hash.delete_if {|x| /http:\/\/t.cn.*/.match(x) }
      cmt = t_hash.select {|a| !a.index('boluome')}.join(" ")
      col = Collector.new(url)
      comment = Comment.new(cmt)
      item = Item.new_with_collector(col)
      item.category ||= "数码"
      item.save!

      binding.pry
  end

end

