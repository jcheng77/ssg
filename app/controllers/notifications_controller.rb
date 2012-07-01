class NotificationsController < ApplicationController
  # GET /user/1/notifications
  # GET /user/1/notifications.json
  def index
    @notifications = Notification.recent_all params[:id]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notifications }
    end
  end

  # GET /user/1/notifications/recent
  # GET /user/1/notifications/recent.json
  def recent
    @notifications = Notification.recent_limit params[:id]
    @length = Notification.receiver_unchecked(params[:id]).length
    array = @notifications.map { |n| {msg: n.to_s, url: notification_path(n)} }

    respond_to do |format|
      format.html # recent.html.erb
      format.json { render json: {:notifications => array, :length => @length} }
    end
  end

  def current_recent
    @notifications = Notification.recent_limit current_user
    @length = Notification.receiver_unchecked(current_user).length
    array = @notifications.map { |n| {msg: n.to_s, url: notification_path(n)} }

    respond_to do |format|
      format.html # recent.html.erb
      format.json { render json: {:notifications => array, :length => @length} }
    end
  end

  # GET /user/1/notifications/1
  # GET /user/1/notifications/1.json
  def show
    @notification = Notification.find(params[:id])
    @notification.set_checked

    respond_to do |format|
      format.html { redirect_to @notification.target_object }
    end
  end
end
