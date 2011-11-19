class CheilSolution < Solution
  def check_read_right(user)

  end

  def check_destroy_right(a_user)
    raise SecurityError
  end

  def can_del_by?(a_user)
    false
  end

  def checked_attaches(reload=false)
    @checked_attaches = nil if reload 
    return @checked_attaches if @checked_attaches

    @checked_attaches = []
    brief.vendor_solutions.each do |vs|
      @checked_attaches += vs.attaches.find_all_by_checked('y')
    end

    return @checked_attaches
  end
end
