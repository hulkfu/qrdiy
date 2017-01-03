class HomeController < ApplicationController
  def index
    if current_user
      @projects = current_user.related_projects
      @statuses = current_user.related_statuses
    else
      # TODO 最新的热门的projects
      @projects = Project.all
      @statuses = Status.all
    end

  end

  def error_404
    render_404
  end
end
