# encoding: utf-8

class ItemsController < ApplicationController
  include TaobaoApiHelper
  include BookmarkletHelper
  include ItemsHelper
  include ImageHelper

  before_filter :select_empty_layout, only: :share
  skip_before_filter :authenticate, :only => [:index, :show]

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

    @result =
        if is_url?(params[:url])
          collector = BookmarkletHelper::Collector.new(params[:url])
          @imgs = collector.imgs

          if collector.succeed?
            @item = Item.new_with_collector(collector)
            @share = @item.shares.last
            {isSuccess: true, shareId: @share._id}
          else
            {isSuccess: false, errorMsg: "分析收藏链接出错啦！"}
          end
        else
          # Search items from Amazon China
          @items = Item.search_on_amazon(params[:url])
          @items = search_item_with_ruyi_api(params[:url]) if @items.blank?

          {isSuccess: false, errorMsg: "不是一个合法的收藏链接！"}
        end

    respond_to do |format|
      format.html { render :layout => 'empty' } # collect.html.erb
      format.js # collect.js.erb
      format.json do
        if @result[:isSuccess]
          if save_item(@item, @share, Share::TYPE_SHARE)
            render json: @result
          else
            render json: {isSuccess: false, errorMsg: "收藏商品出错啦！"}
          end
        else
          render json: @result
        end
      end
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
    @other_prices = EtaoHelper::get_different_price(@item.purchase_url,@item.title)

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
    end
  end

  def create

    respond_to do |format|
      if save_item

        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { redirect_to @item }
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

  def save_item(item = nil, share = nil, type = nil)
    user = current_user
    new_item = item.nil? ? Item.new(params[:item]) : item
    new_share = share.nil? ? Share.new(params[:share]) : share
    share_comment = share.nil? ? params[:share][:comment].to_s : ""
    share_type =
        if type.nil?
          if params[:add_to_wish]
            Share::TYPE_WISH
          elsif params[:add_to_bought]
            Share::TYPE_BAG
          else
            Share::TYPE_SHARE
          end
        else
          type
        end

    @item = Item.first(conditions: {source_id: new_item.source_id})
    if @item
      is_item_new = false
    else
      is_item_new = true
      @item = new_item
      @item.save
    end
    return false unless @item.persisted?

    @share = Share.first(conditions: {item_id: @item._id, user_id: user._id})
    if @share
      return false
    else
      @share = new_share
      @share.item_id = @item._id
      @share.user_id = user._id
      @share.share_type = share_type
      @share.item.auto_tag
      return false if !@share.save

      @share.create_comment_by_sharer(share_comment)
      @item.update_attribute(:root_share_id, @share._id) if is_item_new
      unless share.nil?
        @share.delay.add_tag(params[:wisth_type]) if @share.share_type == Share::TYPE_WISH
      @share.delay.sync_to_weibo(params[:share_to])
      end

      current_user.follow_my_own_share(@share)
      if @share.is_public?
        current_user.push_new_share_to_my_follower(@share)
      end
    end

    return true
  end
end
