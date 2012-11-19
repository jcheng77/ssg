class NotificationsController < ApplicationController
  after_filter :set_all_checked, :only => :index

  # GET /users/1/notifications
  # GET /users/1/notifications.json
  def index
    @user = User.find(params[:id])
    @w_notifs = Notification.recent_of_user(@user, [Notification::TYPE_WISH, Notification::TYPE_SHARE, Notification::TYPE_BAG], params[:w_notifs_page])
    @c_notifs = Notification.recent_of_user(@user, [Notification::TYPE_COMMENT], params[:c_notifs_page])
    @f_notifs = Notification.recent_of_user(@user, [Notification::TYPE_FOLLOW], params[:f_notifs_page])
    @a_notifs = Notification.recent_of_user(@user, [Notification::TYPE_AT_COMMENT], params[:a_notifs_page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notifications }
    end
  end

  # GET /users/1/notifications/1
  # GET /users/1/notifications/1.json
  def show
    @notification = Notification.find(params[:id])
    @notification.set_checked

    respond_to do |format|
      format.html { redirect_to @notification.shown_url, :flash => {:highlighted => @notification.highlighted_object._id} }
    end
  end

  private
  def set_all_checked
    Notification.set_all_checked_of_user(current_user)
  end
end
