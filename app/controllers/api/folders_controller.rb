class Api::FoldersController < Api::ApiController

  def index
  end

  def show
  end

  def create
    @folder = Folder.new(allowed_folder_params)
    @folder.user = current_user
    if @folder.save
      respond_with(@folder, status: 201, default_template: :show)
    else
      invalid_record!
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
