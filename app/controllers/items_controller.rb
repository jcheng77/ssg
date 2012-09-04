class ItemsController < ApplicationController
  layout 'application'
  # GET /items
  # GET /items.json

  include TaobaoApiHelper
  include BookmarkletHelper
  include ItemsHelper
  include ImageHelper

  def index
    @items = Item.in_categories current_categories(params[:category])

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
    col = Collector.new(params[:url])
    @imgs = col.imgs
    item_id = col.item_id
    @item = Item.new
    @share = Share.new

    if item_id

        @item = Item.new({
                             :source_id => item_id,
                             :title => col.title,
                             #:image => product['pic_url'],
                             :image => @imgs.first,
                             :purchase_url => col.purchase_url
                         })
        @share = Share.new({
                               :source => item_id,
                               #:seller => product['nick'],
                               :price => col.price
                           })
    end

    respond_to do |format|
      format.js { render json: @imgs }
      format.html
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

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])
    @share = @item.shares.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = Item.new
    @share = Share.new
    @item_imgs = Array.new

    @id = params[:id] 

    if @id
      product = get_item @id
      if product
        @item_imgs = product["item_imgs"]["item_img"].collect { |img| img["url"] }
        converted_url = convert_item_url @id
        converted_url ||= taobao_url(@id)
        @item = Item.new({
          :source_id => product['num_iid'],
          :title => product['title'],
          #:image => product['pic_url'],
          :image => @item_imgs.first,
          :purchase_url => converted_url
        })
        @share = Share.new({
          :source => product['num_iid'],
          #:seller => product['nick'],
          :price => product['price']
        })
      end
    end

    respond_to do |format|
      format.html { render layout: 'application1' }
    end
  end

  # GET /items/share
  def share
    respond_to do |format|
      format.html { render layout: 'application' }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    @share = Share.first(conditions: {item_id: @item._id, user_id: current_user._id})

    if !@share
      s = Share.first(conditions: {item_id: @item._id})
      @share = Share.new
      @share.source = s.source
    end
  end

  # POST /items
  # POST /items.json
  def create
    respond_to do |format|
      if save_item
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
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

  # DELETE /items/1
  # DELETE /items/1.json
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
      return false if !@item.update_attributes(params[:item])
    else
      @item = Item.new(params[:item])
      return false if !@item.save
    end

    @share = Share.first(conditions: {item_id: @item._id, user_id: user._id})
    if @share
      return false if !@share.update_attributes(params[:share])
    else

      # @category = Category.first(conditions: {cid: params[:category]})
      # @item.add_tag(params[:category])

      @share = Share.new(params[:share])
      @share.item_id = @item._id
      @share.user_id = user._id
      return false if !@share.save
      # binding.pry
      @share.create_comment_by_sharer(params[:share][:comment]) if params[:share][:comment] != ""
      @item.update_attribute(:root_share_id, @share._id)
      current_user.follow @item
      current_user.follow @share
      current_user.followers_by_type(User.name).each { |user| user.follow @share }
    end
    return true
  end

  def taobao_url(taobao_item_id)
    "http://item.taobao.com/item.htm?id=" + taobao_item_id
  end
end
