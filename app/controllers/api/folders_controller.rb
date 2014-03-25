class Api::FoldersController < Api::ApiController
  before_filter :load_folder, except: [:index, :create]

  def index
    record_id = params.delete(:id).to_i
    if record_id == 0
      @items = current_user.folders.roots + current_user.file_items.roots
    else
      record = current_user.folders.find(record_id)
      @items = record.children + record.file_items
    end
    respond_with(@items)
  end

  def show
    respond_with(@folder)
  end

  def create
    parameters = folder_params
    parameters.delete(:parent_id) if parameters[:parent_id] == 0

    @folder = current_user.folders.new(parameters)
    if @folder.save
      respond_with(@folder, status: 201, default_template: :show)
    else
      invalid_record!(@folder)
    end
  end

  def update
    parameters = folder_params
    if parameters[:parent_id] == 0
      parameters.merge!(parent: nil).delete(:parent_id)
    end

    if @folder.update_attributes(parameters)
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
    target_id = params.delete(:parent_id)
    target = current_user.folders.find(target_id)
    begin
      @folder = @folder.copy(target)
      respond_with(@folder, default_template: :show)
    rescue ActiveRecord::RecordInvalid => e
      invalid_record!(e.record)
    end
  end

  private

  def load_folder
    @folder ||= current_user.folders.find(params[:id])
  end

  def folder_params
    params.require(:folder).permit(:name, :parent_id)
  end
end
