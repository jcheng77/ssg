class ChoicesController < ApplicationController
  layout 'application1'
  # GET /users
  # GET /users.json
  # localhost:3000/users/index
  def index
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  # GET /users/new.json
  def new
  end

  # GET /users/1/edit
  def edit
  end
  
  # POST /users
  # POST /users.json
  def create
    @choice = Choice.new(params[:choice])
    @choice.user_id = current_user._id
    
    logger.warn @choice.inspect
    logger.warn Choice.where(object_id_type: @choice.object_id_type, user_id: @choice.user._id, type: @choice.type).inspect
    
    if !Choice.where(object_id_type: @choice.object_id_type, user_id: @choice.user._id, type: @choice.type).empty?
      return redirect_to share_path @choice.object_id_type
    end

    if @choice.save
      redirect_to share_path @choice.object_id
    else
      redirect_to items_path
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @choice = Choice.find(params[:id])
    if @choice && @choice.destroy
      redirect_to share_path @choice.object_id 
    else
      redirect_to items_path  
    end
  end
end
