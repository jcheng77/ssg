# encoding: utf-8

class ItemsController < ApplicationController
  include TaobaoApiHelper
  include BookmarkletHelper
  include ItemsHelper
  include ImageHelper

  before_filter :select_empty_layout, only: :share
  skip_before_filter :authenticate, :only => [:index,:show]

  def index
    if current_user.nil?
      @current_categories = categories
    else
      @current_categories = params[:category].blank? ? current_user.preferences : params[:category].strip.split(" ")
    end
    @hot_tags = Item.top_tags(@current_categories);
    find_tags = current_tags(params[:tag_action], params[:tag])
    @current_tags = params[:tag].to_s.strip.split(" ") | find_tags
    @items = Item.in_categories_and_tags @current_categories, @current_tags, params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @items }
    end
  end

  def search
    tags, @items = Item.search params[:search_content], params[:page]
    current_tags(:set, tags)

    respond_to do |format|
      format.html # search.html.erb
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
    @user = current_user

    if is_url?(params[:url])
      collector = BookmarkletHelper::Collector.new(params[:url])
      @imgs = collector.imgs

      if collector.succeed?
        @item = Item.new_with_collector(collector)
        @share = @item.shares.last
      else
        @item = nil
        @share = nil
      end
    else
      # Search items from Amazon China
      @items = Item.search_on_amazon(params[:url])
      @items = search_item_with_ruyi_api(params[:url]) if @items.blank?
    end

    respond_to do |format|
      format.html { render :layout => 'empty' } # collect.html.erb
      format.js # collect.js.erb
      format.json { render json: @items }
    end
  end

  # POST /items/1/add_tag
  def add_tag
    @item = Item.find(params[:id])
    tag = params[:tag]
    @item.add_tag tag unless tag.blank?

    respond_to do |format|
      format.js # add_tag.js.erb
      format.html { redirect_to @item }
    end
  end

  # POST /items/1/recommend
  def recommend
    @item = Item.find(params[:id])
    @user = current_user

    if params[:comment][:content].blank? || @user.has_shared?(Share::TYPE_SHARE, @item)
      @recommend = nil
      @comment = nil
    else
      @comment = Comment.new(params[:comment])
      share = @comment.root.blank? ? @item.root_share : @comment.root
      @recommend = @user.shares.new share.copy_attributes(:share_type => Share::TYPE_SHARE)
      if @recommend.save
        @comment = @recommend.create_comment_by_sharer @comment.content
        current_user.follow_my_own_share(@recommend)
        current_user.push_new_share_to_my_follower(@recommend)
      end
    end

    respond_to do |format|
      format.html { redirect_to @item }
      format.js { render "comments/create_root" }
    end
  end

  def show
    @item = Item.find(params[:id])
    @share = @item.shares.new
    @s_users = @item.shared_by_users
    @s_users.compact!
    @other_items_from_users = []
    @s_users.each do |su|
      @other_items_from_users << su.shares.desc(:created_at).limit(6)
    end
    @other_items_from_users = @other_items_from_users.flatten![0..5]

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
    # TODO: To be refactor
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
      @share = Share.new(params[:share])
      @share.item_id = @item._id
      @share.user_id = user._id
      @share.share_type =
          if params[:add_to_wish]
            Share::TYPE_WISH
          elsif params[:add_to_bought]
            Share::TYPE_BAG
          else
            Share::TYPE_SHARE
          end
      @share.item.auto_tag

      return false if !@share.save

      @share.create_comment_by_sharer(params[:share][:comment])
      @item.update_attribute(:root_share_id, @share._id)
      @share.delay.add_tag(params[:wisth_type]) if @share.share_type == Share::TYPE_WISH
      @share.delay.sync_to_weibo(params[:share_to])

      current_user.follow_my_own_share(@share)
      if @share.is_public?
      current_user.push_new_share_to_my_follower(@share)
      end

    end

    return true
  end
end
