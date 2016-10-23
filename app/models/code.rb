class Code < ApplicationRecord
  has_many :prints
  dragonfly_accessor :qr_png

  after_create :gen_qr_png

  def qr
    qrcode = ::RQRCode::QRCode.new content
  end

  def gen_qr_png
    update_attribute :qr_png, qr.to_img.to_s
  end
end
