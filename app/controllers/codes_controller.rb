class CodesController < ApplicationController
  before_action :set_code, only: [:show, :edit, :update, :destroy, :download]

  # GET /codes
  # GET /codes.json
  def index
    @codes = Code.all
  end

  # GET /codes/1
  # GET /codes/1.json
  def show
  end

  # GET /codes/new
  def new
    @code = Code.new
  end

  # GET /codes/1/edit
  def edit
  end

  # POST /codes
  # POST /codes.json
  def create
    @code = Code.new(code_params)

    respond_to do |format|
      if @code.save
        format.html { redirect_to @code, notice: 'Code was successfully created.' }
        format.json { render :show, status: :created, location: @code }
      else
        format.html { render :new }
        format.json { render json: @code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /codes/1
  # PATCH/PUT /codes/1.json
  def update
    respond_to do |format|
      if @code.update(code_params)
        format.html { redirect_to @code, notice: 'Code was successfully updated.' }
        format.json { render :show, status: :ok, location: @code }
      else
        format.html { render :edit }
        format.json { render json: @code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /codes/1
  # DELETE /codes/1.json
  def destroy
    @code.destroy
    respond_to do |format|
      format.html { redirect_to codes_url, notice: 'Code was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def download
    send_data(@code.qr_png.data, filename: "qrdiy-#{Time.now.strftime('%Y%m%d%H%M%S')}.png", type: 'img/png', disposition: 'inline')
  end

  # get qr code img png url
  # GET /codes/qr?code[content]=真是牛逼啦！&code[opts][size]=100
  def qr
    @code = Code.new
    @code.content = code_params[:content]
    if @code.save
      @code.gen_qr_png code_params[:opts]
      # send_data(@code.qr.as_png, type: 'img/png', disposition: 'inline')
      render plain: @code.qr_png_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_code
      @code = Code.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def code_params
      params.require(:code).permit(:name, :content, :opts => Code::QR_PNG_DEFAULT_OPTS.keys)
    end
end
