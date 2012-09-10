# encoding: utf-8
class ItemsController < ApplicationController
  include TaobaoApiHelper
  include BookmarkletHelper
  include ItemsHelper
  include ImageHelper

  def index
    categories = current_categories(params[:category])
    @items = Item.in_categories categories, params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  def tagged
    @items = Item.tagged_with_all(params[:tags])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  def index2
    @items = Item.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  def collect
    collector = Collector.new(params[:url])
    @imgs = collector.imgs

    if collector.correct?
      @item = Item.new_with_collector(collector)
      @share = @item.shares.last
    else
      # TODO: 错误处理
      @item = Item.new
      @share = Share.new
    end
  end

  # POST /items/1/add_tag
  def add_tag
    @item = Item.find(params[:id])
    @share = @item.share_by_user current_user
    tag = params[:tag]

    unless tag.blank?
      @item.add_tag tag
      @share.add_tag tag unless @share.nil?
    end

    respond_to do |format|
      format.html { redirect_to @item }
    end
  end

  # POST /items/1/recommend
  def recommend
    @item = Item.find(params[:id])
    @recommend = @item.share_by_user current_user
    @comment = Comment.new(params[:comment])
    has_shared = false

    if @recommend.nil?
      @recommend = @item.shares.create user_id: current_user._id, parent_share_id: @comment.root_id
      @comment = @recommend.create_comment_by_sharer @comment.content
    else
      has_shared = true
    end

    if @recommend.persisted? && @comment.persisted?
      current_user.follow @item
      current_user.follow @recommend
      current_user.followers_by_type(User.name).each { |user| user.follow @recommend }
      respond_to do |format|
        format.html { redirect_to @recommend }
        format.js { render "comments/create_root" }
      end
    else
      @recommend.destroy if !has_shared
      respond_to do |format|
        format.html { redirect_to @item }
        format.js { render "comments/create_root" }
      end
    end
  end

  def show
    @item = Item.find(params[:id])
    @share = @item.shares.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  def edit
    @item = Item.find(params[:id])
    @share = Share.first(conditions: {item_id: @item._id, user_id: current_user._id})

    if !@share
      s = Share.first(conditions: {item_id: @item._id})
      @share = Share.new
      @share.source = s.source
    end
  end

  def create
    respond_to do |format|
      if save_item
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "collect" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if save_item
        format.html { redirect_to @share, notice: 'Item was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :ok }
    end
  end

  protected

  def save_item
    user = current_user
    @share = Share.first(conditions: {source: params[:share][:source]})
    if @share
      @item = Item.first(conditions: {_id: @share.item_id})
      return false unless @item.update_attributes(params[:item])
    else
      @item = Item.new(params[:item])
      return false unless @item.save
    end

    @share = Share.first(conditions: {item_id: @item._id, user_id: user._id})
    if @share
      return false if !@share.update_attributes(params[:share]) || params[:share][:comment].blank?
    else
      # @category = Category.first(conditions: {cid: params[:category]})
      # @item.add_tag(params[:category])

      @share = Share.new(params[:share])
      @share.item_id = @item._id
      @share.user_id = user._id
      return false if !@share.save
      @share.create_comment_by_sharer(params[:share][:comment])
      @item.update_attribute(:root_share_id, @share._id)
      current_user.follow @item
      current_user.follow @share.comment
      current_user.followers_by_type(User.name).each { |user| user.follow @share }
    end

    return true
  end
end
