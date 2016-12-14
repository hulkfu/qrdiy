##
# Relations Controllers
#
class RelationsController < ApplicationController

  ## post /i/domain/relations
  ##
  def create
    @relation = current_user.relations.new(relation_params)

    if @relation.save
      redirect_to :root, notice: "ok"
    end
  end

  def destroy
    @relation = Relation.find(params[:id])
    @relation.destroy
    redirect_to :root, notice: "delete"
  end

  private

    def relation_params
      params.require(:relation).permit(:name, :relationable_id, :relationable_type)
    end
end
