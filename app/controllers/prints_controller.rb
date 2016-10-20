class PrintsController < ApplicationController
  before_action :set_print, only: [:show, :edit, :update, :destroy]

  # GET /codes/prints
  # GET /codes/prints.json
  def index
    @code = Code.find(params[:code_id])
    @prints = @code.prints
  end

  # GET /codes/prints/1
  # GET /codes/prints/1.json
  def show
  end

  # GET /codes/prints/new
  def new
    @print = Print.new
  end

  # GET /codes/prints/1/edit
  def edit
  end

  # POST /codes/prints
  # POST /codes/prints.json
  def create
    @print = Print.new(print_params)

    respond_to do |format|
      if @print.save
        format.html { redirect_to @print, notice: 'print was successfully created.' }
        format.json { render :show, status: :created, location: @print }
      else
        format.html { render :new }
        format.json { render json: @print.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /codes/prints/1
  # PATCH/PUT /codes/prints/1.json
  def update
    respond_to do |format|
      if @print.update(print_params)
        format.html { redirect_to @print, notice: 'print was successfully updated.' }
        format.json { render :show, status: :ok, location: @print }
      else
        format.html { render :edit }
        format.json { render json: @print.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /codes/prints/1
  # DELETE /codes/prints/1.json
  def destroy
    @print.destroy
    respond_to do |format|
      format.html { redirect_to prints_url, notice: 'print was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_print
      @print = Print.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def print_params
      params.require(:print).permit(:title, :description)
    end
end
