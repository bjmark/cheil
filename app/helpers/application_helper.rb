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
    links << link_to('下载',download_attach_path(attach)) if owner.can_read_by?(user.org_id) 
    if owner.can_edit_by?(user.org_id)
      links << link_to('更新',edit_attach_path(attach)) 
      links << link_to('删除',attach_path(attach),
                       {:confirm => 'Are you sure?', :method => :delete})
    end
    if attach.can_checked_by?(user.org_id)
      case attach.checked
        when 'n' then links << link_to('选中',check_attach_path(attach),
                                       {:method => :put})
        when 'y' then links << link_to('取消选中',uncheck_attach_path(attach),
                                       {:method => :put})
        end
    end
    links.join(' | ')
  end

  def new_attach_link(owner,user)
    if owner.can_edit_by?(user.org_id)
      var = case 
            when owner.instance_of?(Brief) then {:brief_id=>owner.id}
            when owner.kind_of?(Solution) then {:solution_id=>owner.id}
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
    if owner.can_commented_by?(user.org_id)
      var = case 
            when owner.instance_of?(Brief) then {:brief_id=>owner.id}
            when owner.kind_of?(Solution) then {:solution_id=>owner.id}
            end
      link_to '新建评论', new_comment_path(var)
    end
  end

  def unread_color
    'color:red'
  end

  def percentage(d)
    f = d.to_f * 100
    i = f.to_i
    f = i if f == i
    "#{f}%"
  end

  def brief_name(brief,opt=nil)
    s = [brief.name]

    opt ||= {}
    opt[:check_read] = true unless opt.has_key?(:check_read)
    opt[:check_status] = true unless opt.has_key?(:check_status)

    if opt[:check_read] and !brief.op.read?(@cur_user.id)
      s << %Q| <span style="color:red;">(新)</span>| 
    end

    if opt[:check_status]
      if brief.cancel?
        s << %Q| <span style="color:red;">(已取消)</span>| 
      elsif Brief::STATUS.keys.include?(brief.status)
        s << %Q| <span style=" color:rgb(227,102,39)">(#{Brief::STATUS[brief.status]})</span>|
      end
    end

    if opt[:append]
      s << opt[:append]
    end

    return raw(s.join)
  end
end
