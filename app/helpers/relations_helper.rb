module RelationsHelper
  def relation_for(relationable, opts={})
    render "relations/form", relationable: relationable, name: opts[:name], submit_name: opts[:submit_name]
  end
end
