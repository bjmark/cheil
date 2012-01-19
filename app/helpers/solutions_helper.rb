#coding=utf-8
module SolutionsHelper
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
end
