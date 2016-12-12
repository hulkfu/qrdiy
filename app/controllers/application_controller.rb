class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: [:index, :show]
  include Pundit
  # TODO 保证所有的 actions 都通过了权限
  # after_action :verify_authorized, except: :index
  # after_action :verify_policy_scoped, only: :index

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def render_404
    render_optional_error_file(404)
  end

  def render_403
    render_optional_error_file(403)
  end

  private

    def user_not_authorized
      flash[:error] = "你没有权限。"
      redirect_to(request.referrer || root_path)
    end

    def render_optional_error_file(status_code)
      respond_to do |format|
        format.html do
          status = status_code.to_s
          fname = %w(404 403 422 500).include?(status) ? status : 'unknown'
          render template: "/errors/#{fname}", format: [:html],
                 handler: [:erb], status: status, layout: 'error'
        end
        format.all { render :nothing => true, :status => 404 }
      end
    end
end
