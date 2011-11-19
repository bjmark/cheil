class VendorSolution < Solution

  def check_destroy_right(a_user)
    return true if can_del_by?(a_user)
    raise SecurityError
  end

  def can_del_by?(a_user)
    assigned_by?(a_user)
  end

  def total
    kinds = [:design,:product,:tran,:other]
    total_hash = {}
    sum_all = 0

    kinds.each do |k|
      sum = 0 
      send("#{k}s".to_sym).each{|e| sum += e.total}
      total_hash[k] = sum
      sum_all += sum
    end

    total_hash[:all] = sum_all
    return total_hash
  end

end
 
