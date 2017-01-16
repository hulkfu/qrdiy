class BaseUploader < CarrierWave::Uploader::Base

  # set file name, so can be private
  def filename
    if original_filename
      # current_path 是 Carrierwave 操作的文件的当前路径。上传过程临时创建的一个文件，
      # 所以 current_path 每次都是不一样的，这也导致即使是同一个 record 的上传文件也是不同的，
      # 这当然是好的。但是对于需要多个 versions 的图片，如同再调用 recreate_versions! 方法
      # 来生成新的 versions，过程是：
      # 1. recreate_versions！：把当前的文件移动到 tmp 文件夹里，名字不变，并生成新的 versions，
      #    文件名是根据上层的目录是新生成的，之后把生成的 versions 拷贝到真正的 store_dir 里。
      # 2. record.save!：这是又会根据 当前的 current_path 生成新的文件名并保存，而当前的
      #    current_path 在 store_dir 里。所以会生成一个不存在新的文件名。
      # 这就是 avatar 的 filename 要根据 store_dir 来定，保证了即使 recreate_versions 也不变。
      # 而直接 create 的时候，不会经历 save 这一步。
      # TODO recreate_versions! 的处理
      name = Digest::MD5.hexdigest(File.dirname(current_path))
      "#{name}.#{file.extension.downcase}"
    end
  end

end
