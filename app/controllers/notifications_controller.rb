class NotificationsController < ApplicationController
  # GET /users/1/notifications
  # GET /users/1/notifications.json
  def index
    @notifications = Notification.recent_all params[:id]

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
      format.html { redirect_to @notification.target_object }
    end
  end
end
