module ApplicationHelper
  def short_d(t)
    #t.strftime('%y-%m-%d')
    t.to_s[0,16]
  end
end
