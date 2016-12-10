class BaseUploader < CarrierWave::Uploader::Base

  # set file name, so can be private
  def filename
    if original_filename
      name = Digest::MD5.hexdigest(File.dirname(current_path))
      "#{name}.#{file.extension}"
    end
  end

end
