class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def render_404
    render_optional_error_file(404)
  end

  def render_403
    render_optional_error_file(403)
  end

  def render_optional_error_file(status_code)
    respond_to do |format|
      format.html do
        status = status_code.to_s
        fname = %w(404 403).include?(status) ? status : 'unknown'
        render template: "/errors/#{fname}", format: [:html],
               handler: [:erb], status: status, layout: 'error'
      end
      format.all { render :nothing => true, :status => 404 }
    end
  end
end
