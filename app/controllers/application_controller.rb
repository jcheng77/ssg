require 'rubygems'
require 'net/http'
require 'uri'
require 'digest/md5'
require 'json'
require 'nestful'
require 'iconv'

class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  

  def current_user
    begin
      @current_user ||= session[:current_user_id] && User.find(session[:current_user_id])
    end
  end
  
end
