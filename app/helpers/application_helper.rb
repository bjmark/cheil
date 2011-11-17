#encoding=utf-8
module ApplicationHelper
  def short_d(t)
    #t.strftime('%y-%m-%d')
    t.to_s[0,16]
  end

  def attaches(owner)
    render 'share/block',
      :title=>'附件',
      :content=>{:partial=>'share/attaches/index',
        :locals=>{:owner=>owner}} unless owner.attaches.empty?
  end

  def attach_links(owner,attach,user)
    links = []
    links << link_to('下载',download_attach_path(attach)) if owner.can_read_by?(user) 
    if owner.can_edit_by?(user)
      links << link_to('更新',edit_attach_path(attach)) 
      links << link_to('删除',attach_path(attach),
                       {:confirm => 'Are you sure?', :method => :delete})
    end
    links.join(' | ')
  end

  def new_attach_link(owner,user)
    if owner.can_edit_by?(user)
      var = case 
            when owner.instance_of?(Brief) then {:brief_id=>owner.id}
            when owner.instance_of?(Solution) then {:solution_id=>owner.id}
            end
      link_to '新建附件', new_attach_path(var)
    end
  end

  def comments(owner)
    render 'share/block',
      :title=>'评论',
      :content=>{:partial=>'share/comments/index',
        :locals=>{:owner=>owner}
    } unless owner.comments.empty?
  end

  def new_comment_link(owner,user)
    if owner.can_commented_by?(user)
      var = case 
            when owner.instance_of?(Brief) then {:brief_id=>owner.id}
            when owner.instance_of?(Solution) then {:solution_id=>owner.id}
            end
      link_to '新建评论', new_comment_path(var)
    end
  end

end
