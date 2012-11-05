# encoding: utf-8
class UsersController < ApplicationController
  include WeiboHelper

  layout 'application'
  skip_before_filter :authenticate, :only => [:signup,:create, :edit]


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
    @shares = @user.followed_all params[:page]

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
    @f_users = @user.followees_by_type(User.name).paginate(:page => params[:f_users_page], :per_page => 8)
    @i_users = @user.known_sns_friends(@user.accounts.first.type).paginate(:page => params[:i_users_page], :per_page => 8)
    @a_users = User.all.sort { |a, b| -(a.shares.size <=> b.shares.size) }.paginate(:page => params[:a_users_page], :per_page => 8)

    respond_to do |format|
      format.html { render layout: 'application' } # friends.html.erb
      format.json { render json: @f_users }
    end
  end

  # POST /users/1/invite
  def invite
    @user = User.find(params[:id])
    @message = params[:message]
    params[:users].to_a.each { |user| @message = "#{@message} @#{user}" }
    @user.update_weibo_status_only_text('sina', weibo_client, @message) if @user.accounts.sina
    @user.update_weibo_status_only_text('qq', weibo_client, @message) if @user.accounts.qq

    respond_to do |format|
      format.html { render :text => @message}
      format.js # invite.js.erb
      format.json { render json: @message }
    end
  end

  # POST /users/search
  def search
    @users = User.search_by_nick_name params[:nick_name]

    respond_to do |format|
      format.html # search.html.erb
      format.js # search.js.erb
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
    @shares = @user.my_shares params[:page]
    respond_to do |format|
      format.html { render layout: 'application' } # my_shares.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/my_wishes
  def my_wishes
    @user = User.find(params[:id])
    @shares = @user.my_wishes params[:page]

    respond_to do |format|
      format.html { render action: :my_shares, layout: 'application' } # my_wishes.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/my_bags
  def my_bags
    @user = User.find(params[:id])
    @shares = @user.my_bags params[:page]

    respond_to do |format|
      format.html { render action: :my_shares, layout: 'application' } # my_bags.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/cycle_shares
  def cycle_shares
    @user = User.find(params[:id])
    @shares = @user.cycle_shares params[:page]

    respond_to do |format|
      format.html { render action: :my_shares, layout: 'application' } # my_bags.html.erb
      format.json { render json: @user }
    end
  end

  def promote_shares
    @user = User.find(params[:id])
    @f_user = User.find_official_weibo_account
    @shares = @f_user.all_my_shares params[:page]

    respond_to do |format|
      format.html { render action: :my_shares, layout: 'application' } # my_bags.html.erb
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
    @user.shares.each { |share| current_user.follow share } if @success

    respond_to do |format|
      format.js
    end
  end

  # GET /users/1/unfollow
  def unfollow
    @user = User.find(params[:id])
    current_user.unfollow @user
    @success = !current_user.follower_of?(@user)
    @user.shares.each { |share| current_user.unfollow share } if @success

    respond_to do |format|
      format.js
    end
  end

  # GET /users/1/edit_preferences
  def edit_preferences
    @user = User.find(params[:id])
    @user.update_attribute(:preferences, @user.preferences & categories)

    respond_to do |format|
      format.html { render "preferences", layout: 'application' }
    end
  end

  # PUT /users/1/update_preferences
  def update_preferences
    @user = User.find(params[:id])
    @user.unset("")
    preferences = params[:user].blank? ? [] : params[:user][:preferences]
    @user.update_attribute :preferences, preferences
    session[:current_categories] = preferences
   if @user.active == 0
    redirect_to :action => 'rec_friends' , :id => @user._id
    return
   end

    respond_to do |format|
      format.html { redirect_to dashboard_user_path(@user) }
    end
  end
  
  # GET /users/1/rec_friends
  def rec_friends
    @user = User.find(params[:id])
    @suggested_friends = @user.suggested_friends(session[:sns_type])
    @user.update_attribute :active, 1

    respond_to do |format|
      format.html 
    end
  end

  # GET /users/1/rec_friendship
  def rec_friendship
    @user = User.find(params[:id])
    users = []
    unless params[:to_follow].blank?
      params[:to_follow].each do |uid|
      @user.follow User.find(uid)
      end
    end
    
    respond_to do |format|
      format.html 
    end
  end

  # GET /users/1/launch
  def launch
    @user = User.find(params[:id])
    sns_type = session[:sns_type]
    if params[:sync_to_weibo] == 1
      client = weibo_client(sns_type)
      #@user.update_weibo_status_only_text(sns_type,client,'想买的东西太多了 愿望清单太长了 好不容易找到了个愿望集散地 开始在这里扎窝晒愿望了 想送我礼物的速还来看看我的愿望清单吧 :-) ')
    end

    respond_to do |format|
      format.html {redirect_to dashboard_user_path(@user)}
      format.json 
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
    else
      @user = User.new(params[:user])
    end
    
      #session[:current_user_id] = @user._id
      #session[:current_user] = nil

    respond_to do |format|
      if !@user.valid?  
        flash[:error] = @user.errors.messages
        format.html { render action: "signup" }
      elsif @user.save!
        session[:current_user_id] = @user._id
        format.html { redirect_to edit_preferences_user_url(@user) }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "signup" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  # PUT /users/1
  # PUT /users/1.json
  def update
    if session[:current_user]
      @user = session[:current_user]
      @user.update_attributes(params[:user])
      session[:current_user_id] = @user._id
      session[:current_user] = nil
    else
      @user = User.new(params[:user])
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        session[:current_user_id] = @user._id
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

    respond_to do |format|
      format.html { render layout: 'application' }
      format.json { head :ok }
    end
  end

  # GET /users/recent_notifications
  def recent_notifications
    @user = current_user
    if @user.nil?
      array = [] , length = 0
    else
      @notifications = Notification.recent_limit @user._id
      @length = Notification.receiver_unchecked(@user._id).length
      array = @notifications.map { |n| {msg: n.to_s, url: notification_path(n)} }
    end

    respond_to do |format|
      format.html { render layout: 'application' }
      format.json { render json: {:notifications => array, :length => @length} }
    end
  end

  # GET /users/all_notifications
  def all_notifications
    @user = current_user

    respond_to do |format|
      format.html { redirect_to notifications_url(@user) }
    end
  end


  def refresh_mention
    @user = current_user
    if @user.is_official_weibo_account?
      @client = weibo_client
      @mentions = fetch_latest_mentions(@client)
      process_weibo_mentions(@mentions)
    end

    respond_to do |format|
      format.html { redirect_to items_path }
    end
  end

  def send_weibo_notifications
    @user = current_user
    if @user.is_official_weibo_account?
      @client = weibo_client
      WeiboQueue.target_hash.each do |name, count|
        msg = "@#{name} 你关注的#{count}个商品有价格变动，速速来查看吧 boluo.me"
        send_weibo_notification(@client, msg)
      end
      WeiboQueue.delete_all
    end
    redirect_to root_path
  end

  def notify_price
    @user = current_user
    if @user.is_official_weibo_account?
    @client = weibo_client
    send_weibo_notification(@client)
    end

    respond_to do |format|
      format.html { redirect_to items_path }
    end
  end

end
