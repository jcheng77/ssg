class WishesController < ApplicationController
  layout 'application'

  # GET /wishes/1
  # GET /wishes/1.json
  def show
    @share = Wish.find(params[:id])
    @item = @share.item

    respond_to do |format|
      format.html { render "items/show" }
      format.json { render json: @share }
    end
  end
end
