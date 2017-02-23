module ApplicationHelper
  ##
  # 显示头像
  #   avatarable: 能显示头像的东西
  #   version：   头像的版本。目前有: big, normal, small, tiny
  #
  def avatar_tag(avatarable, version = :big, opts = {})
    Rails.cache.fetch [:avatar, avatarable, version, opts] do
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

  ##
  # 判断是否是手机
  MOBILE_USER_AGENTS = 'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' \
                     'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' \
                     'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' \
                     'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' \
                     'webos|amoi|novarra|cdm|alcatel|pocket|iphone|mobileexplorer|mobile'
  def mobile?
    agent_str = request.user_agent.to_s.downcase
    return true if turbolinks_app?
    return false if agent_str =~ /ipad/
    agent_str =~ Regexp.new(MOBILE_USER_AGENTS)
  end

end
