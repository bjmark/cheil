#coding=utf-8
module VendorSolutionsHelper
=begin
  def fang_an(e,brief_items_size)
    s = []
    unless e.op.read?(@cur_user.id)
      s << %Q|<span style="#{unread_color}">|
    else
      s << '<span>'
    end
    s << "vendor 方案(#{e.designs.length+e.products.length}/#{brief_items_size})"
    s << '</span>'

    return raw(s.join)
  end

  def vendor_solution_items(solution)
    render 'share/block',
      :title=>'子项',
      :content=>{:partial=>'vendor_solutions/items/index',
        :locals=>{:solution=>solution,:total=>solution.total}
    } unless solution.items.empty?
  end

  def vendor_solution_item_link(item)
    link = []

    if item.solution.org_id == @cur_user.org_id 
      if item.kind == 'design' or item.kind == 'product' 
        link << link_to('报价',edit_price_solution_item_path(item)) 
      else
        link << link_to('修改',edit_solution_item_path(item))  
        link << link_to('删除',solution_item_path(item),:confirm => 'Are you sure?',:method => :delete) 
      end
    end

    if @cur_user.org.instance_of?(CheilOrg)
      unless item.checked?
        link << link_to('选中',check_solution_item_path(item),{:method => :put})
      else
        link << link_to('不选',uncheck_solution_item_path(item),{:method => :put})
      end
    end

    link.join(' | ')
  end
=end
end
