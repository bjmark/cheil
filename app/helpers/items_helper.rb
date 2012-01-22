module ItemsHelper
  def item_kind_selected(n,kind,default)
    case 
    when params["kind_#{n}"]== kind then 'selected'
    when (params["kind_#{n}"].blank? and kind == default) then 'selected'
    end
  end
end
