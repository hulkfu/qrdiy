class Code < ApplicationRecord
  has_many :prints
  dragonfly_accessor :qr_png

  after_create :gen_qr_png

  def qr
    qrcode = ::RQRCode::QRCode.new content
  end

  def gen_qr_png
    png = qr.as_png(
      resize_gte_to: false,
      resize_exactly_to: false,
      fill: 'white',
      color: 'black',
      size: 500,
      border_modules: 4,
      module_px_size: 6,
      file: nil # path to write
    )
    update_attribute :qr_png, png.to_s
  end
end
