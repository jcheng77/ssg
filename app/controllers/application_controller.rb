# encoding: utf-8
require 'rubygems'
require 'net/http'
require 'uri'
require 'digest/md5'
require 'json'
require 'nestful'

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate

  helper_method :current_user, :categories, :current_categories, :need_empty_layout

  def current_user
    @current_user ||= session[:current_user_id] && User.where(:_id => session[:current_user_id]).first
  end

  def current_categories(category = nil)
    @current_categories = session[:current_categories].to_a
    @current_categories = current_user.preferences if @current_categories.nil?
    unless category.blank?
      if @current_categories.include? category
        @current_categories.delete category
      else
        @current_categories << category
      end
      session[:current_categories] = @current_categories
    end
    @current_categories.to_a
  end

  def current_tags(tag = nil)
    @current_tags = session[:current_tags].to_a
    unless tag.blank?
      if @current_tags.include? tag
        @current_tags.delete tag
      else
        @current_tags << tag
      end
      session[:current_tags] = @current_tags
    end
    @current_tags.to_a
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

  def authenticate
    unless session[:current_user_id].nil? || current_user.nil?
      @current_user
    end
  end

  def select_empty_layout
    select_layout('empty')
  end

  def select_layout(selector='default')
    @layout_selector = selector
  end

  def need_empty_layout
    return unless @layout_selector == 'empty'

    true
  end

  def client
     #sina weibo production test api client
      
      @client ||= ( session[:client] || WeiboOAuth2::Client.new( '1734028369','281bbd8a50b59ce1cdadb9d5e8380ab1'))
      WeiboOAuth2::Config.redirect_uri = 'http://boluo.me/syncs/sina/callback/' 

      #@client ||= ( session[:client] || WeiboOAuth2::Client.new( '3788831273','cd9072acaac30aaa6d7a45dc8fff57e3'))
      #WeiboOAuth2::Config.redirect_uri = 'http://boluo.me/syncs/sina/callback/' 

     # client = WeiboOAuth2::Client.new( '419180446','8d97de6064802d452a721e9a64c82310')
     # WeiboOAuth2::Config.redirect_uri = 'http://boluo.me/syncs/sina/callback/' 
      
      #@client ||= ( session[:client] || WeiboOAuth2::Client.new( '1408937818','613b940d9fe14180aa01ce294e1ddf8a') )
      #WeiboOAuth2::Config.redirect_uri = 'http://127.0.0.1:3000/syncs/sina/callback/' 
      @client

      end

end
