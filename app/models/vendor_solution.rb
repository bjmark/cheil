=begin
self:read,delete
attach:read,update
item:read,check,create_tran_other,price_design_product,add_brief_item
comment:read,update

cheil
self:read,delete
attach:read
item:read,add_brief_item
comment:read,update

vendor
self:read
attach:read,update
item:read,create_tran_other,price_design_product
comment:read:update
=end
class VendorSolution < Solution
  def cal
    self.design_sum = self.product_sum = self.tran_sum = self.other_sum = 0 
    self.design_tax_sum = self.product_tax_sum = self.tran_tax_sum = self.other_tax_sum = 0 
    self.design_and_tax_sum = self.product_and_tax_sum = self.tran_and_tax_sum = self.other_and_tax_sum = 0 
    self.all_sum = self.all_tax_sum = self.all_and_tax_sum = 0 

    self.design_c_sum = self.product_c_sum = self.tran_c_sum = self.other_c_sum = 0 
    self.design_c_tax_sum = self.product_c_tax_sum = self.tran_c_tax_sum = self.other_c_tax_sum = 0 
    self.design_c_and_tax_sum = self.product_c_and_tax_sum = self.tran_c_and_tax_sum = self.other_c_and_tax_sum = 0 
    self.all_c_sum = self.all_c_tax_sum = self.all_c_and_tax_sum = 0 

    items.each do |e|
      a = send("#{e.kind}_sum")
      send("#{e.kind}_sum=",a + e.total_up.to_i)

      a = send("#{e.kind}_tax_sum")
      send("#{e.kind}_tax_sum=",a + e.tax.to_i)

      a = send("#{e.kind}_and_tax_sum")
      send("#{e.kind}_and_tax_sum=",a + e.total_up_tax.to_i)

      self.all_sum += e.total_up.to_i
      self.all_tax_sum += e.tax.to_i 
      self.all_and_tax_sum += (e.total_up.to_i + e.tax.to_i) 

      if e.checked == 'y'
        a = send("#{e.kind}_c_sum")
        send("#{e.kind}_c_sum=",a + e.total_up.to_i)

        a = send("#{e.kind}_c_tax_sum")
        send("#{e.kind}_c_tax_sum=",a + e.tax.to_i)

        a = send("#{e.kind}_c_and_tax_sum")
        send("#{e.kind}_c_and_tax_sum=",a + e.total_up_tax.to_i)

        self.all_c_sum += e.total_up.to_i
        self.all_c_tax_sum += e.tax.to_i 
        self.all_c_and_tax_sum += (e.total_up.to_i + e.tax.to_i) 
      end
    end
  end

  def total
    kinds = %w{design product tran other}

    hash = {}

    sum_all_total_up = 0
    sum_all_tax = 0
    sum_all_total_up_tax = 0

    kinds.each do |k|
      sum_total_up = 0
      sum_tax = 0
      sum_total_up_tax =0 

      send("#{k}s".to_sym).each do |e| 
        sum_total_up += e.total_up.to_i
        sum_tax += e.tax.to_i
        sum_total_up_tax += e.total_up_tax.to_i
      end
      hash["#{k}_total_up"] = sum_total_up
      hash["#{k}_tax"] = sum_tax
      hash["#{k}_total_up_tax"]  = sum_total_up_tax

      sum_all_total_up += sum_total_up
      sum_all_tax += sum_tax
      sum_all_total_up_tax += sum_total_up_tax
    end

    hash['all_total_up'] = sum_all_total_up
    hash['all_tax'] = sum_all_tax
    hash['all_total_up_tax'] = sum_all_total_up_tax

    return hash
  end

  def money
    amount = 0
    paid = 0
    brief.cheil_solution.payments.where(:org_id=>org_id).each{|r| paid += r.amount}

    %w{design product tran other}.each do |k|
      amount_k = 0
      send("#{k}s").find_all{|e| e.checked == 'y'}.each{|i| amount_k += i.total}
      amount += amount_k * (1 + send("#{k}_rate").to_f)
    end
    {:amount=>amount,:paid=>paid,:balance=>amount-paid}
  end
end

