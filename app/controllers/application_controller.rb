# encoding: utf-8
#
require 'rubygems'
require 'net/http'
require 'uri'
require 'digest/md5'
require 'json'
require 'nestful'
require 'iconv'

class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :categories, :category 
  

  def current_user
    begin
      @current_user ||= session[:current_user_id] && User.find(session[:current_user_id])
    end
  end

  def categories
    begin
    @categories ||= Category.all(sort: [[ :cid, :asc ]])
    end
  end

  def category
    begin
      @category ||= ['数码','户外','男装','女装','饰品','化妆品','居家','其他']
    end
  end
  
end
