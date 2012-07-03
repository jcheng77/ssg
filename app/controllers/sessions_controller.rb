class SessionsController < ApplicationController
  layout 'application1'
  def new
  end

  def create
  user = User.authenticate(params[:email], params[:password])
  if user
    session[:current_user_id] = user._id
    redirect_to root_url 
  else
    flash.now.alert = "Invalid email or password"
    render "new"
  end
  end

  def destroy
    #Weibo.new('sina').add_status(session[:access_token],session[:token_secret],'Do you know exactly what you really want?')
    #Weibo.new('sina').upload_image(session[:access_token],session[:token_secret],"my handwriting","/Users/jcheng/Pictures/head.jpg") 
    #Weibo.new('sina').upload_image(session[:access_token],session[:token_secret],'I pre-ordered a "new ipad" yesterday...haha..','http://www.hollywoodreporter.com/sites/default/files/2012/03/ipad_3.jpg')
    session[:current_user] = nil
    session[:current_user_id] = nil
    session[:access_token] = nil
    session[:token_secret] = nil
    session[:current_categories] = nil
    redirect_to root_url
  end

end
