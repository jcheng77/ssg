class SessionsController < ApplicationController
  layout 'application'
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
#    Weibo.new('sina').add_status(session[:access_token],session[:token_secret],'I was so stupid....') 
    session[:client].add_status('i was so stupid...')
    session[:current_user_id] = nil
    redirect_to root_url
  end

end
