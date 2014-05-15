module ApplicationHelper
  include FoundationRailsHelper::FlashHelper

  def foundation_icon_for(resource)
    icon = resource.is_a?(Folder) ? 'fi-folder' : 'fi-page'
    content_tag :i, nil, class: "#{icon} large-icon"
  end
end
