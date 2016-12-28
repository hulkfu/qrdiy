class UsersController < ApplicationController
  before_action :set_user_and_profile, only: [:show]

  def show

  end
  private
    def set_user_and_profile
      @user = User.find params[:id]
      @user_profile = @user.profile
    end
end
