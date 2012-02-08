module BriefItemsHelper
  def brief_item_kind_selected(i,kind,default)
    case 
    when @brief_item["kind_#{i}"] == kind then 'selected'
    when (@brief_item["kind_#{i}"].blank? and kind == default) then 'selected'
    end
  end
end
