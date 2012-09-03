class HomeController < ApplicationController
  layout 'application'
  skip_before_filter :authenticate

  def account
    @user = User.find(params[:id])
  end
end
