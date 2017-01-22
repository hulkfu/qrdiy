module RelationsHelper

  ##
  # 发生关系功能
  # 参数
  # relationable 可以发生关系的对象（Project, Publication, User)
  # opts
  #  - TODO cached 为 true 时，异步 relation_tag，页面加载完后才去异步显示
  #  - action_type 关系的类别
  #  - submit_name 显示的提交按钮的内容
  #  - show_count 是否显示发生关系的人数
  #  - class      生成的 div 的附加 class
  #  - button_class 显示的按钮的 class
  #  - create_button_html   创建关系的 html
  #  - destroy_button_html  断绝关系的 thml
  #  - remote  是否 ajax
  def relation_tag(relationable, opts={})
    return "" if relationable.blank?
    return if relationable.is_a? Relation

    # 1. 处理 opts
    cached = opts[:cached] == true
    remote = opts[:remote] == true

    count_html = content_tag(:span, class: "relation-count") {}
    if !cached && opts[:show_count]
      c = relationable.send("who_#{opts[:action_type]}").count
      count_html = content_tag(:span, class: "relation-count") { " #{c.to_s}" if c > 0 }
    end

    create_button_html = content_tag(:span) {opts[:create_button_html] || opts[:submit_name]}
    destroy_button_html = content_tag(:span) {opts[:destroy_button_html] || "已#{opts[:submit_name]}"}

    # 2. 生成 html
    if cached  # 有缓存
      content_tag(:div, id: "relation-#{relationable.class.name}-#{relationable.id}",
        class: "relation #{opts[:action_type]} #{opts[:class]}",
        "data-show-count" => opts[:show_count]) do
          button_tag(remote: remote, class: opts[:button_class]) do
            html = ""
            html << content_tag(:span, class: "create") { create_button_html }
            html << content_tag(:span, class: "destroy hidden") { destroy_button_html }
            html << count_html
            raw html
          end
      end

    else  # 不缓存
      # 用户已经登录，并且发生了关系
      content_tag(:div, id: "relation-#{relationable.class.name}-#{relationable.id}", class: "relation #{opts[:action_type]} #{opts[:class]}") do
        if current_user && relation = current_user.send("#{opts[:action_type]}_relation", relationable)
          render("relations/destroy_form",
            relation: relation,
            remote: remote,
            button_class: opts[:button_class],
            destroy_button_html: destroy_button_html.concat(count_html)
          )
        else
          render("relations/create_form",
            relationable: relationable,
            remote: remote,
            action_type: opts[:action_type],
            button_class: opts[:button_class],
            create_button_html: create_button_html.concat(count_html)
          )
        end
      end # relation div
    end # cache
  end
end
