class HomeController < ApplicationController
  before_filter :select_empty_layout

  layout 'application'
  skip_before_filter :authenticate


  def index
    if current_user
        redirect_to dashboard_user_path(current_user)
    end
  end

end
