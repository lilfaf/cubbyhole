class ShareLinkController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_share_link, only: [:show, :destroy]

  def index
    @share_links = current_user.share_links
  end

  def show
  end

  def create
  end

  def destroy
    @share_links.destroy
  end

  private

  def load_share_link
    @share_link = current_user.find(params[:id])
  end

  def share_link_params
    params.require(:share_link).permit(:emails, :asset_id, :sender_id)
  end
end
