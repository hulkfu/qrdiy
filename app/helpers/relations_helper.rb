module RelationsHelper

  ##
  # 发生关系功能
  # 参数
  # relationable 可以发生关系的对象（Project, Publication, User)
  # opts
  #  - TODO cached 为 true 时，异步 relation_for，页面加载完后才去异步显示
  #  - action_type 关系的类别
  #  - submit_name 显示的提交按钮的内容
  #  - show_count 是否显示发生关系的人数
  #  - class      生成的 div 的附加 class
  #  - button_class 显示的按钮的 class
  #  - create_button_html   创建关系的 html
  #  - destroy_button_html  断绝关系的 thml
  def relation_for(relationable, opts={})
    return "" if relationable.blank?
    return if relationable.is_a? Relation

    count = ""
    if !opts[:cached] && opts[:show_count]
      c = relationable.send("who_#{opts[:action_type]}").count
      count = " #{c}" if c > 0
    end

    content_tag(:div, class: "relation #{opts[:action_type]} #{opts[:class]}") do
      # 不需要 cached，且用户已经登录，并且发生了关系
      if !opts[:cached] && current_user && relation = current_user.send("#{opts[:action_type]}_relation", relationable)
        content_tag(:span, class: "destroy") do
          button_to relation, method: :delete, class: opts[:button_class] do
            html = opts[:destroy_button_html] ?
              opts[:destroy_button_html] :
              "已#{opts[:submit_name]}"
            raw "#{html}#{count.to_s}"
          end
        end
      else
        content_tag(:span, class: "create") do
          form_for(Relation.new) do |f|
            html = ""
            html << f.hidden_field(:action_type, value: opts[:action_type])
            html << f.hidden_field(:relationable_type, value: relationable.class.name)
            html << f.hidden_field(:relationable_id, value: relationable.id)

            html << (button_tag type: "submit", name: "commit", class: opts[:button_class] do
              button_html = opts[:create_button_html] ?
                opts[:create_button_html] :
                "#{opts[:submit_name]}"
              raw(button_html).concat count.to_s
            end) # button_tag
            raw html
          end # form_tag
        end # create span

      end
    end
  end
end
