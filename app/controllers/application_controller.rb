require 'rubygems'
require 'net/http'
require 'uri'
require 'digest/md5'
require 'json'
require 'nestful'
require 'iconv'

class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :user_signed_in?
  
  def call_taobao (method, map)
    app_key = 'test' #'12443313'
    app_sec = 'test' #'sandbox88bf3a4b3d1c9dff28d4890e9'
    p = {
      'format' => 'json',
      'method' => method, #'taobao.user.get',
      'sign_method' => 'md5',
      'timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
      'app_key' => app_key, #'12443313',# 'test',
      'v' => '2.0',
      #'session' => 'sandbox88bf3a4b3d1c9dff28d4890e9'
    }
    p = p.merge map
    p["sign"] = Digest::MD5.hexdigest(app_sec + p.sort.flatten.join + app_sec).upcase

    url = URI.parse('http://gw.api.tbsandbox.com/router/rest')
    resp  = Net::HTTP.post_form(url, p)
    return resp.body
    #Nestful.get 'http://gw.api.tbsandbox.com/router/rest', :params => p
  end

  # return the current login user, if not logged in yet, return new User
  def current_user
    begin
      @current_user ||= session[:current_user_id] && User.find(session[:current_user_id])
      return @current_user? @current_user : User.new
    rescue
      return User.new
    end
  end
  
  # return true if user_signed_in
  def user_signed_in?
    true
  end
end
