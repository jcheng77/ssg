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
  before_filter :authenticate

  helper_method :current_user, :categories, :current_categories, :need_empty_layout

  def current_user
    @current_user ||= session[:current_user_id] && User.where(:_id => session[:current_user_id]).first
  end

  def current_categories(category = nil)
    @current_categories = session[:current_categories]
    @current_categories = current_user.preferences if @current_categories.nil?
    unless category.blank?
      if @current_categories.include? category
        @current_categories.delete category
      else
        @current_categories << category
      end
      session[:current_categories] = @current_categories
    end
    @current_categories
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
end
