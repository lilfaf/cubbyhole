class HomeController < ApplicationController
  layout :page_layout
  before_filter :set_current_user_to_js, if: :user_signed_in?

  def set_current_user_to_js
    gon.current_user = CurrentUserSerializer.new(current_user).to_json
  end

  def page_layout
    user_signed_in? ? 'cubbyhole' : 'application'
  end
end
