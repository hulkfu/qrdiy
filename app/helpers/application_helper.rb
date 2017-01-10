module ApplicationHelper
  ##
  # 显示头像
  #   avatarable: 能显示头像的东西
  #   version：   头像的版本。目前有: big, normal, small, tiny
  #
  def avatar_tag(avatarable, version = :big, opts = {})
    img_class = "avatar #{version}"

    if avatarable.blank?
      return image_tag("avatars/default.png", class: img_class)
    end

    img =
      if avatarable.avatar?
        image_url = avatarable.avatar.url(version)
        image_url += "?t=#{avatarable.updated_at.to_i}" if opts[:timestamp]
        image_tag(image_url, class: img_class)
      else
        image_tag("avatars/default.png", class: img_class)
      end

    options = {
      title: avatarable.name
    }

    if opts[:link] != false
      link_to(raw(img), avatarable, options)
    else
      raw img
    end
  end

end
