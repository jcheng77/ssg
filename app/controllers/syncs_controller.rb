class SyncsController < ApplicationController
  
  def init_client
    case params[:type]
    when 'sina'
    client = OauthChina::Sina.new
    when 'qq'
    client = OauthChina::Qq.new
    end
    return client
  end


  def load_client
    case params[:type]
    when 'sina'
    client = OauthChina::Sina.load(Rails.cache.read(build_oauth_token_key(params[:type],params[:oauth_token])))
    when 'qq'
    client = OauthChina::Qq.load(Rails.cache.read(build_oauth_token_key(params[:type],params[:oauth_token])))
    end
    return client
  end

  def new
    wb = Weibo.new(params[:type])
    wb.init_client
    wb.write_to_cache
    redirect_to wb.client.authorize_url
  end

  #verify account info
  def get_account_info(client)
    case params[:type]
    when 'sina'
    resp = client.get '/account/verify_credentials.json' 
    when 'qq'
    resp = client.get 'http://open.t.qq.com/api/user/info?format=json'
    end
    return resp
  end

  #get the friends list that the given person follows
  def get_friends_ids(client)
    case params[:type]
    when 'sina'
    resp = client.get '/friends/ids.json'
    when 'qq'
    resp = client.get 'http://open.t.qq.com/api/friends/idollist_s?format=json'
    end
    return resp
  end



  def return_user_hash(client)
    if client
    resp = get_account_info(client)
    json_resp = resp.body 
    userhash = ActiveSupport::JSON.decode(json_resp) 
    end
    return userhash 
  end


  def store_friends(client)
    if client
    resp = get_friends_ids(client)
    friends_json= resp.body 
    friends_hash = ActiveSupport::JSON.decode(friends_json) 
    end
    #friends_hash.each_key {|key| logger.info "#{key} => #{friends_hash[key]}"}
    return friends_hash
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


  def callback
    wb = Weibo.new(params[:type])
    wb.load_client(params[:oauth_token])
    wb.client.authorize(:oauth_verifier => params[:oauth_verifier])
    results = wb.client.dump

   # client = load_client
   # client.authorize(:oauth_verifier => params[:oauth_verifier])
   # results = client.dump

    access_token = results[:access_token]
    token_secret = results[:access_token_secret]

    userhash = return_user_hash(client)

## -------------
##  print key-value pair of the returned user object
##  userhash.each_key {|key| logger.info "#{key} => #{userhash[key]}"}
## -------------
    
    friendhash = store_friends(client)
    extract_friends_list(friendhash)
   
    # The hash key of returned json object from QQ weibo is different from the one returned from Sina weibo.
    # So the ids and names needs to be extracted from the json object
    if params[:type] = 'qq'
     userinfo = extract_user_info(userhash) 
    end

    if access_token && token_secret
      oauth_token_key = build_oauth_token_key(client.name,client.oauth_token)
      Rails.cache.write(oauth_token_key, client.dump)
      session[:oauth_token_key] = oauth_token_key

      # 发微博
      client.add_status('Login @ '+Time.new.to_s)
      #wb.client.add_status('Login @ '+Time.new.to_s)
      
      exists = User.where(userid: userinfo["id"].to_s ).first
      if exists.nil?
      user = User.create({ :userid => userinfo["id"]})
      session[:current_user_id] = user._id
      redirect_to :controller => "users", :action => "signup" , :id => user._id , :name => userinfo["name"]
      else
      session[:current_user_id] = exists._id
      redirect_to dashboard_users_path
      end
      
    else
      redirect_to users_url, :notice => "authorized failed!!!! #{access_token} #{token_secret}"
    end
  end


  private


  def build_oauth_token_key(name , oauth_token)
    [name,oauth_token].join("_")
  end

end
