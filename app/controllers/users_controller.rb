class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show

  end

  private
    def set_user
      @user_profile = UserProfile.find_by(domain: params[:domain])
      @user = @user_profile.try(:user)
    end

end
