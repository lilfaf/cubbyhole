class PlansController < ApplicationController
  def index
    @plans = Plan.all
  end

  def show
    @plan = Plan.find params[:id]
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.create plan_params
    if @plan.save
      flash[:notice] = "Plan added successfully"
      redirect_to plans_url
    else
      flash[:alert] = "Create Error."
      render "new"
    end
  end

  def edit
    @plan = Plan.find params[:id]
  end

  def update
    @plan = Plan.find params[:id]
    if @plan.update_attributes plan_params
      flash[:notice] = "Plan updated successfully"
      redirect_to plans_url
    else
      flash[:alert] = "Update Error."
      render "edit"
    end
  end

  def destroy
    @plan = Plan.find params[:id]
    if @plan.destroy
      flash[:notice] = "Plan deleted successfully"
    else
      flash[:alert] = "Destroy Error."
    end
    redirect_to plans_url
  end

  private

  def plan_params
    params.require(:plan).permit(:name, :price, :max_storage_space, :max_bandwidth_up, :max_bandwidth_down, :daily_shared_links_quota)
  end
end
