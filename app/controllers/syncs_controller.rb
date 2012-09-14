require 'oauth2'

include WeiboHelper 

class SyncsController < ApplicationController
  skip_before_filter :authenticate

  def new
    if params[:type] == 'qq'
      wb = Weibo.new(params[:type])
      wb.init_client
      wb.write_to_cache
      redirect_to wb.client.authorize_url
    else
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

      code = client.auth_code.get_token(params[:code])
      userinfo = client.users.show_by_uid(code.params["uid"])
      userinfo = extract_user_info(userinfo)
      

      #client.statuses.upload( "Classic PX200", "http://product.it.sohu.com/img/product/picid/5168051.jpg")
    end

    if (access_token && token_secret) || code

      account = nil
      users = User.all

      users.each do |user|
        account = user.accounts.where(type: params[:type] , aid: userinfo["id"].to_s).first
        break if account
      end

      if account.nil?

        if params[:type] == 'sina'
        bi_friends = client.friendships.friends_bilateral_ids(code.params["uid"] , :count => 300)
        end
        aid = userinfo.delete("id")
        cur_user = User.new(userinfo)
        cur_user.accounts.new( :type => params[:type], :aid => aid, :nick_name => userinfo["name"] , :access_token => access_token || params[:code], :token_secret => token_secret , :avatar => userinfo["profile_image_url"] , :friends => bi_friends.nil? ? [] : bi_friends["ids"]  )

        #user = User.create( :userid => userinfo["id"], :nick_name => userinfo["name"] , :access_token => access_token, :token_secret => token_secret , :avatar => userinfo["profile_image_url"])
        session[:current_user] = cur_user
        redirect_to :controller => "users", :action => "signup"

      else

        session[:current_user_id] = account.user._id

        if params[:type] == 'sina' #&& account.friends.blank?
          friends = client.friendships.friends_bilateral_ids(code.params["uid"] , :count => 300)
          if friends
          new = current_user.accounts.build( friends: friends["ids"] )
          new.save
          end
        end

          redirect_to dashboard_user_path(current_user)
      end

    else
      redirect_to users_url, :notice => "authorized failed!!!! #{access_token} #{token_secret}"
    end
  end

end
