class HomeController < ApplicationController
  layout 'application'
  skip_before_filter :authenticate

  def index
    if current_user
        redirect_to dashboard_user_path(current_user)
    else
      redirect_to root_url
    end
  end

end
