class Code < ApplicationRecord
  has_many :prints
  def qr
    qrcode = ::RQRCode::QRCode.new content
  end
end
