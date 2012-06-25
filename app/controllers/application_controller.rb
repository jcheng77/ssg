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
  helper_method :current_user, :categories, :current_categories

  def current_user
    @current_user ||= session[:current_user_id] && User.find(session[:current_user_id])
  end

  def current_categories(category = nil)
    @current_categories = session[:current_categories]
    @current_categories = [categories.first] if @current_categories.nil?
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

end
