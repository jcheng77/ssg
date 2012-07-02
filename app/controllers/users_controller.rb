class UsersController < ApplicationController
  layout 'application'
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
    @shares = @user.followed_shares current_categories(params[:category])
    respond_to do |format|
      format.html { render layout: 'application' } # dashboard.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/account
  def account
    @user = User.find(params[:id])

    respond_to do |format|
      format.html { render layout: 'application' } # account.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/friends
  def friends
    @user = User.find(params[:id])
    @users = @user.followees_by_type(User.name)

    respond_to do |format|
      format.html { render layout: 'application' } # friends.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1/followees
  def followees
    @user = User.find(params[:id])
    @users = @user.followees_by_type(User.name)

    respond_to do |format|
      format.html { render layout: 'application' } # friends.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1/followers
  def followers
    @user = User.find(params[:id])
    @users = @user.followers_by_type(User.name)

    respond_to do |format|
      format.html { render layout: 'application' } # friends.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1/my_shares
  def my_shares
    @user = User.find(params[:id])
    @shares = @user.my_shares current_categories(params[:category])
    respond_to do |format|
      format.html { render layout: 'application' } # my_shares.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/my_wishes
  def my_wishes
    @user = User.find(params[:id])

    respond_to do |format|
      format.html { render layout: 'application' } # my_wishes.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/my_bags
  def my_bags
    @user = User.find(params[:id])

    respond_to do |format|
      format.html { render layout: 'application' } # my_bags.html.erb
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

  # GET /users/1/follow
  def follow
    @user = User.find(params[:id])
    current_user.follow @user
    @success = current_user.follower_of? @user

    respond_to do |format|
      format.js
    end
  end

  # GET /users/1/unfollow
  def unfollow
    @user = User.find(params[:id])
    current_user.unfollow @user
    @success = !current_user.follower_of?(@user)

    respond_to do |format|
      format.js
    end
  end

  # GET /users/1/edit_preferences
  def edit_preferences
    @user = User.find(params[:id])

    respond_to do |format|
      format.html { render "preferences", layout: 'application' }
    end
  end

  # PUT /users/1/update_preferences
  def update_preferences
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    session[:current_categories] = params[:user][:preferences]

    respond_to do |format|
      format.html { redirect_to dashboard_user_path(@user) }
    end
  end

  # GET /users/1/edit_account
  def edit_account
    @user = User.find(params[:id])

    respond_to do |format|
      format.html { render layout: 'application' }
    end
  end

  # PUT /users/1/update_account
  def update_account
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to account_user_url(@user) }
        format.json { head :ok }
      else
        format.html { render action: "edit_account" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
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

    if session[:current_user]
      @user = session[:current_user]
      @user.update_attributes(params[:user])
      session[:current_user_id] = @user._id
      session[:current_user] = nil
    else
      @user = User.new(params[:user])
    end

    respond_to do |format|
      if @user.save
        session[:current_user_id] = @user._id
        format.html { redirect_to edit_preferences_user_url(@user) }
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
        format.html { redirect_to edit_preferences_user_url(@user) }
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

  # GET /users/signup
  def signup

    @user = session[:current_user]
    @username = params[:name]

    respond_to do |format|
      format.html { render :layout => false}
      format.json { head :ok }
    end

  end

  # GET /users/recent_notifications
  def recent_notifications
    @user = current_user
    @notifications = Notification.recent_limit @user._id
    @length = Notification.receiver_unchecked(@user._id).length
    array = @notifications.map { |n| {msg: n.to_s, url: notification_path(n)} }

    respond_to do |format|
      format.html { render layout: 'application' }
      format.json { render json: {:notifications => array, :length => @length} }
    end
  end
end
