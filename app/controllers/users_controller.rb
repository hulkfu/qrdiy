class UsersController < ApplicationController

  def show
    @user_profile = UserProfile.find_by(domain: params[:domain])
    @user = @user_profile.user
  end
end
