class CommentsController < ApplicationController
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

  # GET /comments/1/vote
  def vote
    comment = Comment.find(params[:id])
    current_user.vote comment, :up
    redirect_to comment.root
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
    @comment = Comment.new(params[:comment])

    if @comment.save
      redirect_to @comment.root
    else
      redirect_to @comment.root
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @comment = Comment.find(params[:id])
    if @comment && @comment.destroy
      redirect_to share_path @comment.object_id 
    else
      redirect_to items_path  
    end
  end
end
