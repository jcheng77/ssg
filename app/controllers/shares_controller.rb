class SharesController < ApplicationController
  layout 'application'

  # GET /shares
  # GET /shares.json
  def index
  end

  # GET /shares/1
  # GET /shares/1.json
  def show
    @share = Share.find(params[:id])
    @item = @share.item

    respond_to do |format|
      format.html { render "items/show" }
      format.json { render json: @share }
    end
  end

  # POST /shares/1/add_to_wish
  def add_to_wish
    @share = Share.find(params[:id])
    @user = current_user

    if params[:content].blank? || @user.has_shared?(Share::TYPE_WISH, @share.item)
      @wish = nil
    else
      @wish = @user.shares.new @share.copy_attributes(:share_type => Share::TYPE_WISH)
      unless params[:tag].blank?
        if @wish.save
          @wish.add_tag params[:tag]
          @wish.create_comment_by_sharer params[:content]
          @user.push_new_share_to_my_follower(@wish)
        end
      end
    end

    respond_to do |format|
      format.js
    end
  end

  # POST /shares/1/add_to_bag
  def add_to_bag
    @share = Share.find(params[:id])
    @user = current_user

    if params[:comment].blank? || @user.has_shared?(Share::TYPE_BAG, @share.item)
      @bag = nil
    else
      @bag = @user.shares.new @share.copy_attributes(:share_type => Share::TYPE_BAG)
      if @bag.save
        @bag.create_comment_by_sharer params[:comment]
        @user.push_new_share_to_my_follower(@bag)
      end
    end

    respond_to do |format|
      format.js
    end
  end

  # GET /shares/new
  # GET /shares/new.json
  def new
  end

  # GET /shares/1/edit
  def edit
    @share = Share.find(params[:id])
    @comment = Comment.new
    @comment.object_id_type = @share._id
  end

  # GET /shares/1/edit
  def choose
    @share = Share.find(params[:id])
    @choice = Choice.new
    @choice.type = params[:type] ? params[:type].to_sym : Choice::TYPE_LIKE
    @choice.object_id_type = @share._id

    #redirect_to :action => "show", :id => @share
  end

  # POST /shares
  # POST /shares.json
  def create
  end

  # PUT /shares/1
  # PUT /shares/1.json
  def update
  end

  # DELETE /shares/1
  # DELETE /shares/1.json
  def destroy
  end
end
