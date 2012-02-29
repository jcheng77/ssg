class SharesController < ApplicationController
  
  # GET /users
  # GET /users.json
  # localhost:3000/users/index
  def index
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @share = Share.find(params[:id])
    
    @comment = Comment.new
    @comment.object_id_type =@share._id
    
    @choice = Choice.new
    @choice.object_id_type =@share._id
  end

  # GET /users/new
  # GET /users/new.json
  def new
  end

  # GET /users/1/edit
  def edit
    @share = Share.find(params[:id])
    @comment = Comment.new
    @comment.object_id_type =@share._id
  end

  # GET /users/1/edit
  def choose
    @share = Share.find(params[:id])
    @choice = Choice.new
    @choice.type = params[:type] ? params[:type].to_sym : Choice::TYPE_LIKE
    @choice.object_id_type =@share._id
    
    #redirect_to :action => "show", :id => @share
  end
  
  # POST /users
  # POST /users.json
  def create
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
  end
end
