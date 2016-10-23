class AddQrPngUidToCodes < ActiveRecord::Migration[5.0]
  def change
    add_column :codes, :qr_png_uid, :string
  end
end
