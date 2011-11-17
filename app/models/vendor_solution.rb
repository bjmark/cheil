class VendorSolution < Solution
  def check_read_right(user)
    return true if super(user) or (brief.cheil_id == user.org_id)
    raise SecurityError
  end

  def check_destroy_right(a_user)
    return true if can_del_by?(a_user)
    raise SecurityError
  end

  def can_del_by?(a_user)
    assigned_by?(a_user)
  end

  
  end
