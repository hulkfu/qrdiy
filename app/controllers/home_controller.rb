class HomeController < ApplicationController
  def index
  end

  def text
    if text_params.present?
      if text_params.include? :qr_id
        @code = Code.find_by_id text_params[:qr_id]
      elsif text_params[:qr_content].present?
        @code = Code.create(content: text_params[:qr_content])
        redirect_to "/text/#{@code.id}"
      end
    end
  end

  def error_404
    render_404
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_code
      @code = Code.try(:find, params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def text_params
      params.permit([:qr_id, :qr_content])
    end
end
