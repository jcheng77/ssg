class InvitationController < ApplicationController
  def new
    @invitation = Invitation.new
    
    respond_to do |format|
      format.html 
      format.json { render json: @invitation}
    end
  end

  def update
    @invitation = Invitation.first(conditions: {:code => params[:code], :used =>  0})
    @invitation.user = current_user
    @invitation.user.activate


    if @invitation
      redirect_to dashboard_user_path(current_user)
    else
      redirect_to root_url
    end
  end

  def index

  end
end
