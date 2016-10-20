class Code < ApplicationRecord
  has_many :prints
  def gen
    qrcode = ::RQRCode::QRCode.new content
    qrcode.as_html
  end
end
