class Code < ApplicationRecord
  has_many :prints
  dragonfly_accessor :qr_png

  before_create :set_id_random

  QR_PNG_DEFAULT_OPTS = {
    # resize_gte_to: false,
    # resize_exactly_to: false,
    fill: 'white',
    color: 'black',
    size: 500,
    border_modules: 4,
    module_px_size: 6,
    # file: nil # path to write
  }

  def qr
    qrcode = ::RQRCode::QRCode.new content
  end

  def gen_qr_png(opts={})
    opts ||= {} # when opts=nil
    clean_opts = {}
    QR_PNG_DEFAULT_OPTS.each do |k, v|
      # if no opt, set default
      # only the keys in defauls can be asigned
      clean_opts[k] = opts[k] || v
      case v
      when Integer
        clean_opts[k] = clean_opts[k].to_i
      end
    end

    png = qr.as_png clean_opts
    update_attribute :qr_png, png.to_s
  end

  def qr_png_url
    if qr_png.nil?
      gen_qr_png
    end
    return qr_png.url
  end

  private
    def set_id_random
      self.id = SecureRandom.hex(18)
    end
end
