module WeiboHelper
  #extract id and name and profile image infomation from the json object returned from QQ weibo
  KEY_MAP = {"openid" => "id" , "name" => "name" , "head" => "profile_image_url", "location" => "location", "email" => "email" , "birth_day" => "birth_day", "birth_month" => "birth_month", "birth_year" => "birth_year", "birthday" => "birthday" }

  def extract_user_info(hash)
    if hash.has_key?('data')
      hashdata = hash["data"]
      userhash = Hash[hashdata.map { |k,v| [ KEY_MAP[k], v ] }]
      #userhash = { "id" => hashdata["openid"], "name" => hashdata["name"] , "profile_image_url" => hashdata["head"], "location" => hashdata["location"], "email" => hashdata["email"] , "birthday" => "#{hashdata["birth_year"]}#{hashdata["birth_month"]}#{hashdata["birth_day"]}" , "description" => hashdata["description"] }
    else
      hash.select {|k,v| KEY_MAP.values.index(k) }
    end  
  end
end
