##
# Relations Controllers
#
class RelationsController < ApplicationController

  ## post /i/domain/relations
  ##
  def create
    @relation = current_user.all_relations.new(relation_params)

    if @relation.save
      redirect_to :back, notice: "ok"
    end
  end

  def destroy
    @relation = Relation.find(params[:id])
    @relation.destroy
    redirect_to :back, notice: "delete"
  end

  private

    def relation_params
      params.require(:relation).permit(:name, :relationable_id, :relationable_type)
    end
end
