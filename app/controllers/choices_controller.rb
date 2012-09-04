class ChoicesController < ApplicationController

  def create
    @choice = Choice.new(params[:choice])
    @choice.user_id = current_user._id

    logger.warn @choice.inspect
    logger.warn Choice.where(object_id_type: @choice.object_id_type, user_id: @choice.user._id, type: @choice.type).inspect

    if !Choice.where(object_id_type: @choice.object_id_type, user_id: @choice.user._id, type: @choice.type).empty?
      return redirect_to share_path @choice.object_id_type
    end

    if @choice.save
      redirect_to share_path @choice.object_id
    else
      redirect_to items_path
    end
  end

  def destroy
    @choice = Choice.find(params[:id])
    if @choice && @choice.destroy
      redirect_to share_path @choice.object_id
    else
      redirect_to items_path
    end
  end
end
