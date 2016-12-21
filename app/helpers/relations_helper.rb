module RelationsHelper
  def relation_for(relationable, opts={})
    if relation = current_user.send("#{opts[:name]}_relation", relationable)
      # TODO 将 不再 改成可定义的 html
      button_to "不再#{opts[:submit_name]}", relation, method:"delete"
    else
      render "relations/form", relationable: relationable,
        name: opts[:name], submit_name: opts[:submit_name]
    end
  end
end
