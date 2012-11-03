include WeiboHelper 

class SyncsController < ApplicationController
  skip_before_filter :authenticate

  def new
    if params[:type] == 'qq'
      wb = Weibo.new(params[:type])
      wb.write_to_cache
      redirect_to wb.client.authorize_url
    else
      redirect_to weibo_client.authorize_url
    end
  end


  def callback
    session[:sns_type] =  params[:type]
    bi_friends = []
    friends_ids =  []
    friends_names = []

    if params[:type] == 'qq'
      wb = Weibo.new(params[:type])
      wb.load_client(params[:oauth_token])
      wb.client.authorize(:oauth_verifier => params[:oauth_verifier])
      results = wb.client.dump

      access_token = session[:access_token] = results[:access_token]
      token_secret = session[:token_secret] = results[:access_token_secret]
      userinfo = wb.get_user_info_hash
      
      friends_ids , friends_names = wb.get_friends_list userinfo["id"]
    else

      client = weibo_client
      code = client.auth_code.get_token(params[:code])
      session[:access_token] = code.token
      session[:refresh_token] = code.refresh_token
      session[:expires_at] = code.expires_at

      userinfo = client.users.show_by_uid(code.params["uid"])
      userinfo = extract_user_info(userinfo)
      bi_friends = client.friendships.friends_bilateral(code.params["uid"] , :count => 200)
      if bi_friends.has_key?("users")
        bi_friends["users"].each do |u|
        friends_ids << u["idstr"].to_s
        friends_names << u["screen_name"]
      end
    end
    end

    if (access_token && token_secret) || code

      account = nil

      User.all.each do |user|
        account = user.accounts.where(type: params[:type] , aid: userinfo["id"].to_s).first
        break if account
      end


      if account.nil?

        
        access_token ||= ( session[:access_token] || code.token )
        token_secret ||=  ( session[:token_secret] || session[:refresh_token] )
        cur_user = User.create_user_account_with_weibo_hash(params[:type],userinfo,access_token, token_secret,friends_ids,friends_names)

        session[:current_user] = cur_user
        redirect_to :controller => "users", :action => "signup"

      else
        access_token ||= ( session[:access_token] || code.token )
        token_secret ||=  ( session[:token_secret] || session[:refresh_token] )
        account.update_attributes({access_token: access_token, token_secret: token_secret,expires_at: session[:expires_at]  })


        session[:current_user_id] = account.user._id
        account.update_attributes({friends: friends_ids, friends_names: friends_names})
        redirect_to promote_shares_user_path(current_user)

      end

    else
      redirect_to users_url, :notice => "authorized failed!!!! #{access_token} #{token_secret}"
    end
  end

end
