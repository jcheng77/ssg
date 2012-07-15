class HomeController < ApplicationController
  layout 'application'
  skip_before_filter :authenticate
  
  def index
  end
  
  def register
  end

  def account
    @user = User.find(params[:id])
  end


end
