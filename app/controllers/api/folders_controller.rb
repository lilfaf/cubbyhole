class Api::FoldersController < Api::ApiController
  before_filter :prevent_root_copy, only: :copy
  before_filter :load_folder, except: [:create]

  def index
    @items = @folder.children.load + @folder.file_items
    @items.sort_by(&:created_at)
    respond_with(@items)
  end

  def show
    respond_with(@folder)
  end

  def create
    @folder = current_user.folders.new(params_hash)
    if @folder.save
      respond_with(@folder, status: 201, default_template: :show)
    else
      invalid_record!(@folder)
    end
  end

  def update
    if @folder.update_attributes(params_hash)
      respond_with(@folder, default_template: :show)
    else
      invalid_record!(@folder)
    end
  end

  def destroy
    @folder.destroy
    respond_with(@folder, status: 204)
  end

  def copy
    target = current_user.folders.find(params[:parent_id])
    begin
      @folder = @folder.copy(target)
      respond_with(@folder, default_template: :show)
    rescue ActiveRecord::RecordInvalid => e
      invalid_record!(e.record)
    end
  end

  private

  def load_folder
    param_id = params[:id].to_i
    param_id = current_user.root_folder.id if param_id == 0
    @folder ||= current_user.folders.find(param_id)
  end

  def params_hash
    # Folder with 0 index points to the current user root folder
    parameters = allowed_folder_params
    if parameters[:parent_id] == 0
      parameters.merge!({parent_id: current_user.root_folder.id})
    end
    parameters
  end

  def allowed_folder_params
    params.require(:folder).permit(:name, :parent_id)
  end

  def prevent_root_copy
    if params[:id].to_i == 0 && action_name == 'copy'
      raise Errors::ForbiddenOperation
    end
  end
end
