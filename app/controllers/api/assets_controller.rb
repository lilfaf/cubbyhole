class Api::AssetsController < Api::ApiController
  before_filter :load_asset, except: [:index, :create]

  def index
    @assets = if folder_id
                current_user.folders.find(folder_id).assets
              else
                current_user.assets.roots
              end
    respond_with(@assets)
  end

  def show
    @asset = current_user.assets.find(params[:id])
    respond_with(@asset)
  end

  def create
    @asset = if folder_id
               folder = current_user.folders.find(folder_id)
               folder.assets.new(asset_params.merge(user_id: current_user.id))
             else
               current_user.assets.new(asset_params)
             end

    if @asset.save
      respond_with(@asset)
    else
      invalid_record!(@asset)
    end
  end

  def update
    @asset = current_user.assets.find(params[:id])
    parameters = asset_params

    # move action
    if folder_id = parameters.delete(:parent_id)
      @asset.folder = if folder_id == 0
                        nil
                      else
                        current_user.folders.find(folder_id)
                      end
      @asset.save!
    end

    if @asset.update_attributes(parameters)
      respond_with(@asset)
    else
      invalid_record!(@asset)
    end
  end

  def destroy
    @asset.destroy
    head :no_content
  end

  def copy

  end

  def content
    @asset = current_user.assets.find(params[:id])
    redirect_to @asset.url
  end

  private

  def folder_id
    value = params[:parent_id].to_i
    value == 0 ? nil : value
  end

  def asset_params
    params.require(:file).permit(:name, :key, :size, :content_type, :etag, :parent_id)
  end

  def load_asset
    @asset ||= current_user.assets.find(params[:id])
  end
end
