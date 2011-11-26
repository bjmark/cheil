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
    sum_all_r = 0

    kinds.each do |k|
      sum = 0 
      send("#{k}s".to_sym).each{|e| sum += e.total}
      total_hash[k] = sum

      sum_r = sum * (send("#{k}_rate").to_f + 1) 
      total_hash["#{k}_r".to_sym] = sum_r
      
      sum_all += sum
      sum_all_r += sum_r
    end

    total_hash[:all] = sum_all
    total_hash[:all_r] = sum_all_r
    return total_hash
  end

end
 
