class HomeController < ApplicationController
  def index
    redirect_to folders_path if user_signed_in?
  end

  def features
  end

  def prices
  end
end
