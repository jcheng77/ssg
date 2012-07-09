class SyncsController < ApplicationController
  layout 'application1'

  def new
    wb = Weibo.new(params[:type])
    wb.init_client
    wb.write_to_cache
    redirect_to wb.client.authorize_url
  end



  def callback
    wb = Weibo.new(params[:type])
    wb.load_client(params[:oauth_token])
    wb.client.authorize(:oauth_verifier => params[:oauth_verifier])
    results = wb.client.dump


    access_token = session[:access_token] = results[:access_token]
    token_secret = session[:token_secret] = results[:access_token_secret]

    userinfo = wb.get_user_info_hash


    if access_token && token_secret


      #exists = User.where(userid: userinfo["id"].to_s ).first
      account = nil
      users = User.all
      users.each do |user| 
        account = user.accounts.where(type: params[:type] , aid: userinfo["id"].to_s).first
        break if account
      end 
        

      #exists = User.all.each.accounts.where(aid: userinfo["id"].to_s ).first

      if account.nil?
      
      binding.pry
      aid = userinfo.delete("id")
      cur_user = User.new(userinfo)
      cur_user.accounts.new( :type => params[:type], :aid => aid, :nick_name => userinfo["name"] , :access_token => access_token, :token_secret => token_secret , :avatar => userinfo["profile_image_url"])


      #
      #user = User.create( :userid => userinfo["id"], :nick_name => userinfo["name"] , :access_token => access_token, :token_secret => token_secret , :avatar => userinfo["profile_image_url"])
      #
      session[:current_user] = cur_user
      redirect_to :controller => "users", :action => "signup" 

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
