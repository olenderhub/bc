module ApplicationHelper
  def title_of_site
    params[:controller].humanize
  end
end
