class Api::FoldersController < Api::ApiController

  def index
  end

  def show
  end

  def create
    @folder = current_user.folders.new(allowed_folder_params)
    if @folder.save
      respond_with(@folder, status: 201, default_template: :show)
    else
      invalid_record!(@folder)
    end
  end

  def update
  end

  def destoy
  end

  def copy
  end

private

  def allowed_folder_params
    params.require(:folder).permit(:name, :parent_id)
  end
end
