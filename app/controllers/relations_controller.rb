##
# Relations Controllers
#
class RelationsController < ApplicationController

  ## post /i/domain/relations
  ##
  def create
    @relation = authorize current_user.all_relations.new(relation_params)

    if @relation.save
      redirect_to (request.referer || root_path), notice: "已#{@relation.desc}"
    end
  end

  def destroy
    @relation = authorize Relation.find(params[:id])
    @relation.destroy
    redirect_to (request.referer || root_path), notice: "已取消#{@relation.desc}"
  end

  private

    def relation_params
      params.require(:relation).permit(:action_type, :relationable_id, :relationable_type)
    end
end
