class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_project, only: [:show, :edit, :update, :destroy, :create_reply]

  # GET /projects
  # GET /projects.json
  def index
    authorize Project
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    # Project 里只需要出现有用的东西，即 pubications 的 status
    # 而且只要 add type 的 status，一般就是 publication.statuses.first
    # 不带 comments 等的 statuses
    # 所以不用：@statuses = @project.all_statuses
    @publications = @project.publications.where.not(publishable_type: "Comment")
  end

  # 回应项目，发布想法、图片等
  def create_reply
    begin
      @publication = Publication.create_publishable!(params[:publishable_type],
        publishable_params,
        {content: params[:reply][:content], user: current_user, project: @project})
      redirect_to @project, notice: "发布成功！"
    rescue Exception => e
      redirect_to @project, alert: "#{e.message}."
    end
  end

  def change_reply_type
    @type = params[:type]
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

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: '项目创建成功！' }
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
        format.html { redirect_to @project, notice: '项目更新成功。' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: '项目删除成功。' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :description)
    end

    def publishable_params
      params.require(:reply).permit(:attachment, {image_array: []})
    end
end
