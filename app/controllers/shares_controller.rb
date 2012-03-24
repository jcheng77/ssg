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
