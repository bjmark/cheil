class CheilSolution < Solution
  def check_read_right(user)

  end

  def check_destroy_right(a_user)
    raise SecurityError
  end

  def can_del_by?(a_user)
    false
  end

end
