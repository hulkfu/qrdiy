class UserProfilesController < ApplicationController
  before_action :set_user_profile, only: [:show, :edit, :update, :destroy]



  # GET /i/user_id/profile
  def show
  end

  # GET /i/user_id/profile/edit
  def edit
  end

  # PATCH/PUT /i/user_id/profile
  def update
    respond_to do |format|
      if @user_profile.update(user_profile_params)
        format.html { redirect_to @user, notice: '个人信息更新成功！' }
        format.json { render :show, status: :ok, location: @user_profile }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_profile
      @user = User.find params[:user_id]
      @user_profile = @user.profile
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_profile_params
      params.require(:user_profile).permit(:name, :domain, :avatar, :homepage, :location, :gender, :birthday, :description)
    end
end
