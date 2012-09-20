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

  helper_method :current_user, :categories, :current_categories, :current_tags, :need_empty_layout

  def current_user
    @current_user ||= session[:current_user_id] && User.where(:_id => session[:current_user_id]).first
  end

  def current_categories(action = nil, category = nil)
    @current_categories = session[:current_categories].to_a
    @current_categories = current_user.preferences if @current_categories.blank?
    unless category.blank?
      case action
        when 'delete'
          @current_categories.delete category
        when 'add'
          @current_categories << category unless @current_categories.include? category
      end
      session[:current_categories] = @current_categories
    end
    @current_categories.to_a
  end

  def current_tags(action = nil, tag = nil)
    @current_tags = session[:current_tags].to_a
    unless tag.blank?
      case action.to_s
        when 'delete'
          @current_tags.delete tag
        when 'add'
          @current_tags << tag unless @current_tags.include? tag
        when 'set'
          @current_tags = tag.to_a
      end
      session[:current_tags] = @current_tags
    end
    @current_tags.to_a
  end

  def current_tags=(tags = [])
    @current_tags = session[:current_tags] = tags
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

  def weibo_client
    #sina weibo production test api client

    #@client ||= (session[:client] || WeiboOAuth2::Client.new('1734028369', '281bbd8a50b59ce1cdadb9d5e8380ab1'))
    #WeiboOAuth2::Config.redirect_uri = 'http://boluo.me/syncs/sina/callback/'

    #@client ||= ( session[:client] || WeiboOAuth2::Client.new( '3788831273','cd9072acaac30aaa6d7a45dc8fff57e3'))
    #WeiboOAuth2::Config.redirect_uri = 'http://boluo.me/syncs/sina/callback/'

    # client = WeiboOAuth2::Client.new( '419180446','8d97de6064802d452a721e9a64c82310')
    # WeiboOAuth2::Config.redirect_uri = 'http://boluo.me/syncs/sina/callback/'

    @client ||= WeiboOAuth2::Client.new( '1408937818','613b940d9fe14180aa01ce294e1ddf8a')
    WeiboOAuth2::Config.redirect_uri = 'http://127.0.0.1:3000/syncs/sina/callback/'

    if !@client.authorized? && !session[:access_token].nil?
      @client.get_token_from_hash(:access_token => session[:access_token], :refresh_token => session[:refresh_token] , :expires_at => session[:expires_at] )
    end
    @client
  end

end
