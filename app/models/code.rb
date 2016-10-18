class Code < ApplicationRecord
  def gen
    qrcode = ::RQRCode::QRCode.new content
    qrcode.as_html
  end
end
