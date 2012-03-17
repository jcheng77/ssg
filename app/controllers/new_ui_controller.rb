class NewUiController < ApplicationController
  layout 'new_application'
  def index
    # render 'index'
  end

  def my_shares
    render layout: 'shares'
  end
end