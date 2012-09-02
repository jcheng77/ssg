class BagsController < ApplicationController
  layout 'application'

  # GET /bags/1
  # GET /bags/1.json
  def show
    @share = Bag.find(params[:id])
    @item = @share.item

    respond_to do |format|
      format.html { render "items/show" }
      format.json { render json: @share }
    end
  end
end
