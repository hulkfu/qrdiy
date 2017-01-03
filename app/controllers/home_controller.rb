class HomeController < ApplicationController
  def index
    if current_user
      @projects = current_user.related_projects
      @statuses
    else
      # 最新的热门的projects
    end

  end

  def error_404
    render_404
  end
end
