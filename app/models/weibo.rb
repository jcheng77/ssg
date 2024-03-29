class Weibo

  KEY_MAP = {"openid" => "id" , "name" => "name" , "head" => "profile_image_url", "location" => "location", "email" => "email" , "birth_day" => "birth_day", "birth_month" => "birth_month", "birth_year" => "birth_year", "birthday" => "birthday" }

  def initialize(type)
    @type = type
    case @type
    when 'qq'
      @client = OauthChina::Qq.new
    when 'sina'
    sinaapp = load_sina_config
    @client = WeiboOAuth2::Client.new(sinaapp["key"], sinaapp["secret"])
    WeiboOAuth2::Config.redirect_uri = sinaapp["callback"]
    end
  end


  def client
    @client
  end

  def write_to_cache
    #binding.pry
    case @type
      when 'qq'
        Rails.cache.write(build_oauth_token_key(@client.name,@client.oauth_token), @client.dump)
      when 'sina'
        Rails.cache.write(build_oauth_token_key('sina',oauth_))
    end
  end

  def load_client(oauth_token)
    case @type
    when 'qq'
      #binding.pry
      @client = OauthChina::Qq.load(Rails.cache.read(build_oauth_token_key(@type,oauth_token)))
    when 'sina'
      @client.get_token_from_hash(:access_token => oauth_token[:access_token], :refresh_token => oauth_token[:refresh_token], :expires_at => oauth_token[:expires_at])
    end
  end

  def load_from_db(access_token,token_secret, expires_at = nil)
    case @type
    when 'qq'
      @client = OauthChina::Qq.load(:access_token => access_token,:access_token_secret => token_secret)
    when 'sina'
      @client.get_token_from_hash(:access_token => access_token, :refresh_token => token_secret, :expires_at => expires_at)
    end
  end

  #verify account info
  def get_account_info
      resp = @client.get 'http://open.t.qq.com/api/user/info?format=json'
    return resp
  end

  #get the friends list that the given person follows
  def get_friends_ids_names(uid)
      resp = @client.get('http://open.t.qq.com/api/friends/mutual_list?format=json&fopenid='+ uid + '&startindex=0&req_num=30')
    return resp
  end

  def get_friends_ids
      resp = @client.get 'http://open.t.qq.com/api/friends/mutual_list?format=json' 
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

    return extract_user_info(userhash)
  end

  def get_friends_list(uid)
    if @client
      resp = get_friends_ids_names(uid)
      friends_json= resp.body 
      friends_hash = ActiveSupport::JSON.decode(friends_json) 
    end
      return extract_friends_list(friends_hash)
  end

  #extract id and name and profile image infomation from the json object returned from QQ weibo
  def extract_user_info(hash)
    if hash.has_key?('data')
      hashdata = hash["data"]
      userhash = Hash[hashdata.map { |k,v| [ KEY_MAP[k], v ] }]
      #userhash = { "id" => hashdata["openid"], "name" => hashdata["name"] , "profile_image_url" => hashdata["head"], "location" => hashdata["location"], "email" => hashdata["email"] , "birthday" => "#{hashdata["birth_year"]}#{hashdata["birth_month"]}#{hashdata["birth_day"]}" , "description" => hashdata["description"] }
    else
      hash.select {|k,v| KEY_MAP.values.index(k) }
    end
  end

  def extract_friends_list(qqhash)
    friends_ids  = []
    friends_names = []
    unless qqhash['data'].blank?
      friends_list = qqhash['data']['info']
      friends_list.to_a.each do |friend|
        friends_ids << friend["openid"]
        friends_names << friend["name"]
      end
    end
    [friends_ids, friends_names]
  end

  def add_status(message,pic=nil)
    if pic.nil?
    case @type
    when 'qq'
    message.force_encoding('utf-8')
    @client.add_status(message)
    when 'sina'
    message.force_encoding('utf-8')
    @client.statuses.update(message)
    end
    else
     add_status_with_pic(message,pic)
    end
  end

  def upload_image(access_token,token_secret,message,image_path)
    load_from_db(access_token,token_secret)
    message.force_encoding('utf-8')
    @client.upload_image(message,image_path)
  end

  def upload_image_url(message,image_path)
    @client.upload_image_url(message.force_encoding('utf-8'),image_path)
  end

  def add_status_with_pic(message, pic)
    case @type
      when 'qq'
       @client.upload_image_url(message.force_encoding('utf-8'),image_path)
      when 'sina'
       @client.statuses.upload_url_text({:status => message.force_encoding('UTF-8'),:url => pic} )
    end
  end

  def fetch_latest_mentions
    if Status.exists?
      @client.statuses.mentions(:since_id => Status.all.last.last_since_id) 
    else
      @client.statuses.mentions
    end
  end


  private

  def build_oauth_token_key(name , oauth_token)
    [name,oauth_token].join("_")
  end

  def load_sina_config
    YAML.load_file(Rails.root.join("config/oauth","sina.yml"))[Rails.env]
  end



end
