class AssetsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_parent_folder

  def new
    if request.xhr?
      render :new, layout: false
    else
      redirect_to folders_path
    end
  end

  def create
    @asset = if @parent_folder
               @parent_folder.assets.new(asset_params)
             else
               Asset.new(asset_params)
             end

    @asset.user = current_user
    @asset.save
  end

  def destroy
    @asset = current_user.assets.find(params[:id])
    @asset.destroy
  end

  private

  def load_parent_folder
    @parent_folder ||= current_user.folders.find(params[:parent_id]) if params[:parent_id]
  end

  def asset_params
    params.require(:asset).permit(:key)
  end
end
