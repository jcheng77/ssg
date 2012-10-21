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
        last_id = share_hash[:weibo_status_id] 
        if Status.exists?
          Status.update_all(last_since_id: last_id)
        else
          Status.create(last_since_id: last_id)
        end
      end
    end
  end


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
    if Status.exists?
       Status.update_all(last_since_id: q.weibo_status_id) if q
    else
       Status.create(last_since_id: q.weibo_status_id) if q
    end
  end

end
