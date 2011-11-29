class VendorSolution < Solution

  def check_read_right(_org_id)
    can_read_by?(_org_id) or raise SecurityError
  end

  alias :check_comment_right :check_read_right

  def can_read_by?(_org_id)
    can_edit_by?(_org_id) or assigned_by?(_org_id)
  end

  alias :can_commented_by? :can_read_by?

  alias :can_edit_by? :owned_by?
  
  def check_edit_right(_org_id)
    can_edit_by?(_org_id) or raise SecurityError
  end

  def assigned_by?(_org_id)
    brief.received_by?(_org_id)
  end

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

  def money
    amount = 0
    paid = 0
    brief.cheil_solution.payments.where(:org_id=>org_id).each{|r| paid += r.amount}

    %w{design product tran other}.each do |k|
      amount_k = 0
      send("#{k}s").checked.each{|i| amount_k += i.total}
      amount += amount_k * (1 + send("#{k}_rate").to_f)
    end
    {:amount=>amount,:paid=>paid,:balance=>amount-paid}
  end
end

