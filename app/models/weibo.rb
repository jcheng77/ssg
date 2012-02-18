class Weibo

  def initialize(type)
   @type = type 
  end
  
  def init_client
    case @type
    when 'sina'
    @client = OauthChina::Sina.new
    when 'qq'
    @client = OauthChina::Qq.new
    end
  end

  def client
    @client
  end

  def write_to_cache
    Rails.cache.write(build_oauth_token_key(@client.name,@client.oauth_token), @client.dump)
  end


  def load_client(oauth_token)
    case @type
    when 'sina'
    @client = OauthChina::Sina.load(Rails.cache.read(build_oauth_token_key(@type,oauth_token)))
    when 'qq'
    @client = OauthChina::Qq.load(Rails.cache.read(build_oauth_token_key(@type,oauth_token)))
    end
  end


  def load_from_db(access_token,token_secret)
    case @type
    when 'sina'
    @client = OauthChina::Sina.load(:access_token => access_token,:token_secret => token_secret)
    when 'qq'
    @client = OauthChina::Qq.load(:access_token => access_token,:token_secret => token_secret)
    end
  end


  #verify account info
  def get_account_info
    case @type
    when 'sina'
    resp = @client.get '/account/verify_credentials.json' 
    when 'qq'
    resp = @client.get 'http://open.t.qq.com/api/user/info?format=json'
    end
    return resp
  end

  
#get the friends list that the given person follows
  def get_friends_ids
    case @type
    when 'sina'
    resp = @client.get '/friends/ids.json'
    when 'qq'
    resp = @client.get 'http://open.t.qq.com/api/friends/idollist_s?format=json'
    end
    return resp
  end


  

    ## -------------
    ##  print key-value pair of the returned user object
    ##  userhash.each_key {|key| logger.info "#{key} => #{userhash[key]}"}
    ## -------------
  def get_user_info_hash
    if @client
    resp = get_account_info
    json_resp = resp.body 
    userhash = ActiveSupport::JSON.decode(json_resp) 
    end
    # The hash key of returned json object from QQ weibo is different from the one returned from Sina weibo.
    # So the ids and names needs to be extracted from the json object

    if @type == 'qq'
      return extract_user_info(userhash)
    else
      return userhash
    end
  end


  def get_friends_list
    if @client
    resp = get_friends_ids
    friends_json= resp.body 
    friends_hash = ActiveSupport::JSON.decode(friends_json) 
    end
    friends_hash.each_key {|key| Rails.logger.info "#{key} => #{friends_hash[key]}"}
    if @type == 'qq'
      return extract_friends_list(friends_hash)
    else
      return friends_hash["ids"]
    end
  end


  #extract id and name and profile image infomation from the json object returned from QQ weibo
  def extract_user_info(hash)
    if hash.has_key?('data')
      userhash = { "id" => hash["data"]["openid"], "name" => hash["data"]["name"] , "profile_image_url" => hash["data"]["head"]}
      return userhash
    end  
    return hash
  end


  def extract_friends_list(qqhash)
    if qqhash.has_key?('data')
      friends_list = qqhash['data']['info']
      friends_ids = friends_names = []
      friends_list.each do |friend| 
        friends_ids << friend["openid"]
        friends_names << friend["name"]
      end
    end
  end

  def add_status(access_token,token_secret,message)
#    @client = OauthChina::Sina.load(Rails.cache.read(token))
#    # 发微博
#    @client.add_status('Logout @ '+Time.new.to_s)
    load_from_db(access_token,token_secret)
    @client.add_status(message)
  end


  private

  def build_oauth_token_key(name , oauth_token)
    [name,oauth_token].join("_")
  end

  
  
end
