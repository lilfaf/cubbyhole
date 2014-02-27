class Api::FoldersController < Api::ApiController
  before_filter :load_folder, only: [:index, :show]

  def index
    @items = @folder.children.load + @folder.file_items
    @items.sort_by(&:created_at)
    respond_with(@items)
  end

  def show
    respond_with(@folder)
  end

  def create
    # Modify the params so that index 0 points
    # to the current user root folder
    params_hash = allowed_folder_params
    if params_hash[:parent_id] == 0
      params_hash[:parent_id] = current_user.root_folder.id
    end

    @folder = current_user.folders.new(params_hash)
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

  def load_folder
    param_id = params[:id].to_i
    param_id = current_user.root_folder.id if param_id == 0
    @folder ||= current_user.folders.find(param_id)
  end

  def allowed_folder_params
    params.require(:folder).permit(:name, :parent_id)
  end
end
