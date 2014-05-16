class FoldersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @items = current_user.folders.roots + current_user.assets.roots
  end

  def show
    @folder = current_user.folders.find(params[:id])
    @items  = @folder.children + @folder.assets

    render :index
  end

  def new
    @parent = current_user.folders.find(params[:parent_id]) if params[:parent_id]
    @folder = Folder.new

    if request.xhr?
      render :new, layout: false
    else
      redirect_to folders_path
    end
  end

  def create
    @folder = current_user.folders.new(folder_params)

    respond_to do |format|
      if @folder.save
        format.html { redirect_to folders_path }
        format.js
      else
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @folder = current_user.folders.find(params[:id])
    @folder.destroy
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :parent_id)
  end
end
