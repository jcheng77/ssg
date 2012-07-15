class HomeController < ApplicationController
  layout 'application'
  def index
  end
  
  def register
  end

  def account
    @user = User.find(params[:id])
  end


end
