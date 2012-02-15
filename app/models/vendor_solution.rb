=begin
self:read,delete
attach:read,update
item:read,check,create_tran_other,price_design_product,assign_brief_item
comment:read,update

cheil
self:read,delete
attach:read,check
item:read,check
comment:read,update

vendor
self:read
attach:read,update
item:read,create_tran_other,price_design_product
comment:read:update
=end
class VendorSolution < Solution
  def total
    kinds = [:design,:product,:tran,:other]
    total_hash = {}
    sum_all = 0
    sum_all_r = 0

    kinds.each do |k|
      sum = 0 
      send("#{k}s".to_sym).each{|e| sum += e.total}
      total_hash[k] = sum

      sum_r = (sum * (send("#{k}_rate").to_f + 1)).to_i 
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

