# encoding: utf-8
require 'rubygems'
require 'net/http'
require 'uri'
require 'digest/md5'
require 'json'
require 'nestful'
require 'iconv'

class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :categories

  def current_user
    @current_user ||= session[:current_user_id] && User.find(session[:current_user_id])
  end

=begin
  def categories
    begin
      @categories ||= Category.all(sort: [[:cid, :asc]])
    end
  end
=end

  def categories
    @categories ||= ['数码', '户外', '男装', '女装', '饰品', '化妆品', '居家', '其他']
  end
end
