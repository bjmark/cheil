class VendorSolution < Solution
  def check_read_right(user)
    return true if super(user) or (brief.cheil_id == user.org_id)
    raise SecurityError
  end
end
