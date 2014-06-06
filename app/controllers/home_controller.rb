class HomeController < ApplicationController
  def index
    redirect_to folders_path if user_signed_in?
    @plans = Plan.all
  end
end
