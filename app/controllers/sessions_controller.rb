#encoding: utf-8
class SessionsController < ApplicationController
  def destroy
    #Weibo.new('qq').add_status(session[:access_token],session[:token_secret],'Knowledge is power. Pass it on...')
    #Weibo.new('sina').upload_image(session[:access_token],session[:token_secret],"my handwriting","/Users/jcheng/Pictures/head.jpg") 
    #Weibo.new('qq').upload_image(session[:access_token],session[:token_secret],'skydrive is fast','https://sc.imp.live.com/content/dam/imp/surfaces/mail_signin/v3/images/SignIn_SkyDrive_en.jpg')
    session[:current_user] = nil
    session[:current_user_id] = nil
    session[:access_token] = nil
    session[:token_secret] = nil
    session[:current_categories] = nil
    redirect_to root_url
  end
end
