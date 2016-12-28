module RelationsHelper
  ##
  # 发生关系功能
  # 参数
  # relationable 可以发生关系的对象（Project, Publication, User)
  # opts
  #  - action_type 关系的类别
  #  - submit_name 显示的提交按钮的内容
  #  - show_count 是否显示发生关系的人数
  #  - button_class 显示的按钮的 class
  def relation_for(relationable, opts={})
    return "" if relationable.blank?
    return if relationable.is_a? Relation

    count = ""
    if opts[:show_count]
      c = relationable.send("who_#{opts[:action_type]}").count
      count = "(#{c})" if c > 0
    end
    content_tag(:div, class: "relation #{opts[:action_type]}") do
      if current_user && relation = current_user.send("#{opts[:action_type]}_relation", relationable)
        # TODO 可定义的 html
        content_tag(:span, class: "remove") do
          button_to relation, method: :delete, class: opts[:button_class] do
             "已#{opts[:submit_name]}#{count}"
          end
        end
      else
        content_tag(:span, class: "add") do
          render "relations/form", relationable: relationable,
            button_class: opts[:button_class],
            action_type: opts[:action_type],
            submit_name: opts[:submit_name]<<count
        end
      end
    end
  end
end
