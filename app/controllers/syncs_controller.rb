require 'oauth2'

include UsersHelper

class SyncsController < ApplicationController
  skip_before_filter :authenticate

  def new
    if params[:type] == 'qq'
      wb = Weibo.new(params[:type])
      wb.init_client
      wb.write_to_cache
      redirect_to wb.client.authorize_url
    else
      client = WeiboOAuth2::Client.new( '3788831273','cd9072acaac30aaa6d7a45dc8fff57e3')
      WeiboOAuth2::Config.redirect_uri = 'http://boluo.me/syncs/sina/callback/' 

      #client = WeiboOAuth2::Client.new( '1408937818','613b940d9fe14180aa01ce294e1ddf8a')
      #WeiboOAuth2::Config.redirect_uri = 'http://127.0.0.1:3000/syncs/sina/callback/' 

      redirect_to client.authorize_url
    end
  end

  def callback
    if params[:type] == 'qq'
      wb = Weibo.new(params[:type])
      wb.load_client(params[:oauth_token])
      wb.client.authorize(:oauth_verifier => params[:oauth_verifier])
      results = wb.client.dump

      access_token = session[:access_token] = results[:access_token]
      token_secret = session[:token_secret] = results[:access_token_secret]
      userinfo = wb.get_user_info_hash
    else
      #sina weibo production test api client
      client = WeiboOAuth2::Client.new( '3788831273','cd9072acaac30aaa6d7a45dc8fff57e3')
      WeiboOAuth2::Config.redirect_uri = 'http://boluo.me/syncs/sina/callback/' 

      #sina weibo localhost test api client
      #client = WeiboOAuth2::Client.new( '1408937818','613b940d9fe14180aa01ce294e1ddf8a')
      #WeiboOAuth2::Config.redirect_uri = 'http://127.0.0.1:3000/syncs/sina/callback/' 

      code = client.auth_code.get_token(params[:code])
      userinfo = client.users.show_by_uid(code.params["uid"])
      userinfo = extract_user_info(userinfo)
      bi_friends = client.friendships.friends_bilateral_ids(code.params["uid"])
    end

    if (access_token && token_secret) || code

      #exists = User.where(userid: userinfo["id"].to_s ).first
      account = nil
      users = User.all

      users.each do |user|
        account = user.accounts.where(type: params[:type] , aid: userinfo["id"].to_s).first
        break if account
      end

      #exists = User.all.each.accounts.where(aid: userinfo["id"].to_s ).first

      if account.nil?

        aid = userinfo.delete("id")
        userinfo = 
        cur_user = User.new(userinfo)
        cur_user.accounts.new( :type => params[:type], :aid => aid, :nick_name => userinfo["name"] , :access_token => access_token, :token_secret => token_secret , :avatar => userinfo["profile_image_url"] , :friends => bi_friends["ids"])

        #user = User.create( :userid => userinfo["id"], :nick_name => userinfo["name"] , :access_token => access_token, :token_secret => token_secret , :avatar => userinfo["profile_image_url"])
        session[:current_user] = cur_user
        redirect_to :controller => "users", :action => "signup"
        #redirect_to dashboard_user_path(current_user)

      else

        session[:current_user_id] = account.user._id
        if current_user.active == 1 || current_user.active == 0
          redirect_to dashboard_user_path(current_user)
        else
          redirect_to :controller => "invitation" , :action => "new"
        end
      end

    else
      redirect_to users_url, :notice => "authorized failed!!!! #{access_token} #{token_secret}"
    end
  end
end
