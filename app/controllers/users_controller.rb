class UsersController < ApplicationController
  layout 'application1'
  #before_filter :authenticate_user!
  
  # GET /users
  # GET /users.json
  # localhost:3000/users/index
  def index
    @users = User.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1/dashboard
  def dashboard
    @user = User.find(params[:id])

    respond_to do |format|
      format.html { render layout: 'application' } # dashboard.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/friends
  def friends
    @user = User.find(params[:id])

    respond_to do |format|
      format.html { render layout: 'application' } # friends.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/my_shares
  def my_shares
    @user = User.find(params[:id])

    respond_to do |format|
      format.html { render layout: 'application' } # my_shares.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def select
    @user = User.find(params[:id])
    session[:current_user_id]=@user._id.to_s

    redirect_to :action => "index"
#    redirect_to :action => "show", :id => @user
  end

  # GET /users/1
  # GET /users/1.json
  def follow
    
    @user = current_user
    @user.follow(params[:id])

    redirect_to :action => "index"
#    redirect_to :action => "show", :id => @user
  end
  
  def unfollow
    @user = current_user
    @user.unfollow(params[:id])

    redirect_to :action => "index"
#   redirect_to :action => "show", :id => @user
  end
  
  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end


  def signup
    @user = User.find(params[:id])
    session[:current_user_id] = @user._id 
    @username = params[:name]
  end


end
