class SyncsController < ApplicationController
  

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


    access_token = results[:access_token]
    token_secret = results[:access_token_secret]

    userinfo = wb.get_user_info_hash


    if access_token && token_secret
#      oauth_token_key = build_oauth_token_key(wb.client.name,wb.client.oauth_token)
#      Rails.cache.write(oauth_token_key, wb.client.dump)
      session[:client] = wb.client
#      session[:oauth_token_key] = oauth_token_key
      session[:access_token] = access_token
      session[:token_secret] = token_secret

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
