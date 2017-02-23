class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    authorize Project
    @projects = Project.all.paginate(page: params[:page])
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @statuses = @project.statuses_to_show.paginate(page: params[:page], per_page: Project::STATUSES_PER_PAGE)
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = current_user.projects.new(project_params)
    authorize @project
    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'DIY 创建成功！' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'DIY 更新成功。' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  # TODO soft delete
  def destroy
    # @project.destroy
    # respond_to do |format|
    #   format.html { redirect_to projects_url, notice: 'DIY 删除成功。' }
    #   format.json { head :no_content }
    # end
    redirect_to '/'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.friendly.find(params[:id])
      authorize @project
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :avatar, :desc, :description)
    end
end
