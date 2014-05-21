class AssetsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_parent_folder, only: [:new, :create]
  before_filter :load_asset, only: [:download, :destroy]

  def show
  end

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
    @asset.destroy
  end

  def download
    redirect_to @asset.asset_url(query: {'response-content-disposition' => 'attachment'})
  end

  private

  def load_parent_folder
    @parent_folder ||= current_user.folders.find(params[:parent_id]) if params[:parent_id]
  end

  def load_asset
    @asset = current_user.assets.find(params[:id])
  end

  def asset_params
    params.require(:asset).permit(:key)
  end
end
