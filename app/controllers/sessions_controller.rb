class SessionsController < ApplicationController
  def new
  end

  def create
  user = User.authenticate(params[:email], params[:password])
  if user
    session[:current_user_id] = user.id
    redirect_to root_url 
  else
    flash.now.alert = "Invalid email or password"
    render "new"
  end
  end

  def destroy
    client = OauthChina::Sina.load(Rails.cache.read(session[:oauth_token_key]))
    # 发微博
    client.add_status('Logout @ '+Time.new.to_s)
      
    
    session[:current_user_id] = nil
    redirect_to root_url
  end

end
