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
      redirect_to weibo_client.authorize_url
    end
  end


  def callback
    session[:sns_type] =  params[:type]
    if params[:type] == 'qq'
      wb = Weibo.new(params[:type])
      wb.load_client(params[:oauth_token])
      wb.client.authorize(:oauth_verifier => params[:oauth_verifier])
      results = wb.client.dump

      access_token = session[:access_token] = results[:access_token]
      token_secret = session[:token_secret] = results[:access_token_secret]
      userinfo = wb.get_user_info_hash
    else

      client = weibo_client
      code = client.auth_code.get_token(params[:code])
      session[:access_token] = code.token
      session[:refresh_token] = code.refresh_token
      session[:expires_at] = code.expires_at

      userinfo = client.users.show_by_uid(code.params["uid"])
      userinfo = extract_user_info(userinfo)


      

      #client.statuses.upload( "Classic PX200", "http://product.it.sohu.com/img/product/picid/5168051.jpg")
    end

    if (access_token && token_secret) || code

      account = nil

      User.all.each do |user|
        account = user.accounts.where(type: params[:type] , aid: userinfo["id"].to_s).first
        if account && user.accounts.sina
          user.accounts.destroy_all
          bi_friends = client.friendships.friends_bilateral_ids(code.params["uid"] , :count => 300)
          aid = userinfo.delete("id")
          profile_url = userinfo.delete("profile_url")
          account = user.accounts.create( :type => params[:type], :aid => aid, :nick_name => userinfo["name"] , :access_token => access_token || params[:code], :token_secret => token_secret , :avatar => userinfo["profile_image_url"] , :friends => bi_friends.nil? ? [] : bi_friends["ids"] , :profile_url => profile_url )
        end
        break if account
      end

      if account.nil?

        if params[:type] == 'sina'
          bi_friends = client.friendships.friends_bilateral_ids(code.params["uid"] , :count => 300)
        end
        #retrieve the info that belongs to account model
        aid = userinfo.delete("id")
        profile_url = userinfo.delete("profile_url")

        
        cur_user = User.new(userinfo)
        cur_user.accounts.new( :type => params[:type], :aid => aid, :nick_name => userinfo["name"] , :access_token => access_token || params[:code], :token_secret => token_secret , :avatar => userinfo["profile_image_url"] , :profile_url => profile_url )

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
        #running the monitoring weibo status
        end
        redirect_to dashboard_user_path(current_user)
      end

    else
      redirect_to users_url, :notice => "authorized failed!!!! #{access_token} #{token_secret}"
    end
  end

end
