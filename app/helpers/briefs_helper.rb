#encoding=utf-8
module BriefsHelper
  def brief_items(brief)
    render 'share/block',:title=>'子项',
      :content=>{:partial=>'briefs/items/index',
        :locals=>{:brief=>brief}} unless brief.items.empty?
  end

  def brief_items_kind(brief,items,kind_cn)
    render 'briefs/items/kind',
      :brief=>brief,
      :items=>items,
      :kind_cn=>kind_cn unless items.empty?
  end
end
