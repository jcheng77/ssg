class CommentsController < ApplicationController
  layout 'application'
  # GET /comments
  # GET /comments.json
  def index
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/1/vote
  def vote
    @comment = Comment.find(params[:id])
    @success = current_user.vote @comment, :up

    respond_to do |format|
      format.html { redirect_to @comment.root }
      format.js # vote.js.erb
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(params[:comment])
    @comment.save
    current_user.follow @comment.root
    current_user.follow @comment.root.comment
    respond_to do |format|
      format.html { redirect_to @comment.root }
      format.js { render @comment.is_root_comment? ? "create_root" : "create_child" }
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    if @comment && @comment.destroy
      redirect_to share_path @comment.object_id
    else
      redirect_to items_path
    end
  end
end
