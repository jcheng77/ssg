class HomeController < ApplicationController
  def index
    redirect_to '/index.html'
  end
  
  def register
  end

  def account
    @user = User.find(params[:id])
  end


end
