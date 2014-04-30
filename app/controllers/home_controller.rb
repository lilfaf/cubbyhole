class HomeController < ApplicationController
  layout :page_layout

  def page_layout
    user_signed_in? ? 'cubbyhole' : 'application'
  end
end
