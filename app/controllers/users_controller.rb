class UsersController < ApplicationController
  before_action :set_user_and_profile, only: [:show]

  def show
    @statuses = @user.all_statuses.includes(:user, :project, :statusable)
      .paginate(page: params[:page])
  end

  # TODO: edit passwords...

  private
    def set_user_and_profile
      @user = User.friendly.find params[:id]
    end
end
