##
# Relations Controllers
#
class RelationsControllers < ApplicationController
  # post /i/domain/relations
  def create
    @relation = @user.relations.new(relation_params)

    if @relation.save
    end
  end

  def destroy

  end

  private
    def set_user
      @user = User.find_by(user_domain: params[:user_domain])
    end

    def relation_params
      params.require(:user_project_relation)
        .permit(:relation, :relationable_id, :relationable_type)
    end
end
