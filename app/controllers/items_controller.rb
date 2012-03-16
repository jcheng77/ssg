class ItemsController < ApplicationController
  layout 'application'
  # GET /items
  # GET /items.json
  def index
    @items = Item.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])
    
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

    @id=  params[:id] #246883

    if @id
      @json_str = call_taobao "taobao.item.get", {"num_iid"=> @id, "fields" => "detail_url,num_iid,title,nick,type,cid,seller_cids,props,input_pids,input_str,desc,pic_url,num,valid_thru,list_time,delist_time,stuff_status,location,price,post_fee,express_fee,ems_fee,has_discount,freight_payer,has_invoice,has_warranty,has_showcase,modified,increment,approve_status,postage_id,product_id,auction_point,property_alias,item_img,prop_img,sku,video,outer_id,is_virtual,skus"}
      @json_obj = JSON.parse(@json_str)
      if(@json_obj["item_get_response"])
        product = @json_obj["item_get_response"]["item"]

        @item_imgs = product["item_imgs"]["item_img"].collect { |img| img["url"] }
        binding.pry
        @item = Item.new({
          :title => product['title'],
          #:image => product['pic_url'],
          :image => @item_imgs[0]
        })
        @share = Share.new({
          :source => product['num_iid'],
          #:seller => product['nick'],
          :price => product['price'],
        })
      end
    end    

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end
  
  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    @share = Share.first(conditions: {item_id: @item._id, user_id: current_user._id})
    
    if !@share
      s = Share.first(conditions: {item_id: @item._id})
      @share=Share.new
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
  
  def save_item
    user = current_user
    @share = Share.first(conditions: {source: params[:share][:source]})
    
    if @share
      @item = Item.first(conditions: {_id: @share.item_id})
    elsif
      @item = Item.new(params[:item])
    end
    
    if @share
      return false if !@item.update_attributes(params[:item])
    else
      return false if !@item.save
    end
    @share = Share.first(conditions: {item_id: @item._id, user_id: user._id})
    if @share
      return false if !@share.update_attributes(params[:share])
    elsif
      @share = Share.new(params[:share])
      @share.item_id = @item._id
      @share.user_id = user._id
      return false if !@share.save
      
      user.notify_my_share(@share)
    end
    return true
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
end
