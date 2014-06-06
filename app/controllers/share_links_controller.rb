class ShareLinksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_share_link, only: [:show, :destroy]

  def index
    @share_links = current_user.share_links
  end

  def show
  end

  def new
    @asset ||= current_user.assets.find(params[:asset_id]) if params[:asset_id]
    @share_link = ShareLink.new

    if request.xhr?
      render :new, layout: false
    else
      render :new
    end
  end

  def create
    @share_link = ShareLink.create_with_emails(share_link_params)
    @share_link.sender = current_user

    respond_to do |format|
      if @share_link.save

        @share_link.emails.each do |email|
          ShareLinkMailer.delay.link_email(current_user, @share_link, email.body)
        end

        format.html { redirect_to folders_path }
        format.js
      else
        format.json { render json: @share_link.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @share_links.destroy
  end

  private

  def load_share_link
    @share_link ||= current_user.find(params[:id])
  end

  def share_link_params
    params.require(:share_link).permit(:emails_list, :asset_id)
  end
end
