module ApplicationHelper
  include FoundationRailsHelper::FlashHelper

  def foundation_icon_for(resource)
    icon = resource.is_a?(Folder) ? 'fi-folder' : 'fi-page'
    content_tag :i, nil, class: "#{icon} large-icon"
  end

  def breadcrumbs(folder)
    folder ||= Folder.new
    content_tag :ul, class: 'breadcrumbs' do
      concat(content_tag(:li) { link_to 'Root', folders_path })
        folder.self_and_ancestors.collect do |f|
          css_class = (folder == f) ? 'current' : ''
          concat(content_tag(:li, class: css_class) { link_to f.name, folder_path(f) })
        end
    end.html_safe
  end
end
