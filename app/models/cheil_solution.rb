#encoding=utf-8
=begin
self:read

cheil
self:read
=end
class CheilSolution < Solution
  def cal
    self.design_c_sum = self.product_c_sum = self.tran_c_sum = self.other_c_sum = 0

    self.brief.vendor_solutions.each do|e|
      self.design_c_sum += e.design_c_sum
      self.product_c_sum += e.product_c_sum
      self.tran_c_sum += e.tran_c_sum
      self.other_c_sum += e.other_c_sum
    end
  end

  def check_approve_right(_org_id)
    can_approved_by?(_org_id) or raise SecurityError
  end

  def can_approved_by?(_org_id)
    brief.owned_by?(_org_id)
  end

  def approved?
    is_approved == 'y'
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

  def checked_designs(reload=false)
    @checked_designs = nil if reload
    return @checked_designs if @checked_designs

    @checked_designs = []
    brief.vendor_solutions.each do |vs|
      @checked_designs += vs.designs.find_all{|e| e.checked == 'y' }
    end

    return @checked_designs
  end

  def checked_products(reload=false)
    @checked_products = nil if reload
    return @checked_products if @checked_products

    @checked_products = []
    brief.vendor_solutions.each do |vs|
      @checked_products += vs.products.find_all{|e|e.checked == 'y'}
    end

    return @checked_products
  end

  def checked_trans(reload=false)
    @checked_trans = nil if reload
    return @checked_trans if @checked_trans

    @checked_trans = []
    brief.vendor_solutions.each do |vs|
      @checked_trans += vs.trans.find_all{|e| e.checked == 'y'}
    end

    return @checked_trans
  end

  def checked_others(reload=false)
    @checked_others = nil if reload
    return @checked_others if @checked_others

    @checked_others = []
    brief.vendor_solutions.each do |vs|
      @checked_others += vs.others.find_all{|e| e.checked == 'y' }
    end

    return @checked_others
  end

  def checked_items
    checked_designs + checked_products + checked_trans + checked_others
  end

  def total
    kinds = [:design,:product,:tran,:other]  #四种类型报价
    sum_all = 0      #总计
    sum_all_r = 0    #税后总计
    total_hash = {}  #分项结果

    kinds.each do |k|  #对每种类型的item
      total_hash[k]=[]  #每种类型，每个vendor的报价合计
      brief.vendor_solutions.each do |vs|    #对brief的每个vendor方案
        sum = 0           #合计
        vs.send("#{k}s").checked.collect{|e| sum += e.total} #累加选中的某种类型的item
        sum = sum.to_i    #抹去小数点后的部分
        if sum > 0
          total_hash[k] << 
          {:name=>vs.org.name,
            :sum=>sum,                                  
            :rate=>(rate=vs.send("#{k}_rate")),        #税率
            :sum_r=>(sum_r=(sum*(1+rate.to_f)).to_i)}  #税后，抹去小数点后的部分
          sum_all += sum
          sum_all_r += sum_r
        end
      end

      sum = 0  #cheil自己的方案
      send("#{k}s").collect{|e| sum += e.total}
      sum = sum.to_i

      if sum > 0
        total_hash[k] << 
        {:name=>org.name,
          :sum=>sum,
          :rate=>(rate=send("#{k}_rate")),
          :sum_r=>(sum_r=(sum*(1+rate.to_f)).to_i)}
        sum_all += sum
        sum_all_r += sum_r
      end
      if total_hash[k].length > 1
        sub_sum_all = 0 
        sub_sum_all_r = 0
        total_hash[k].each do |e| 
          sub_sum_all += e[:sum]
          sub_sum_all_r += e[:sum_r]
        end
        total_hash[k] << 
        {:name=>'分项累计',
          :sum=>sub_sum_all,
          :rate=>'',
          :sum_r=>sub_sum_all_r
        }
      end
    end
    total_hash[:all]=[]
    total_hash[:all] << 
    {:name=>'全部累计',
      :sum=>sum_all,
      :rate=>'',
      :sum_r=>sum_all_r
    }
    return total_hash
  end

  def vendor_money
    lst=[]
    brief.vendor_solutions.each do |e|
      amount = 0
      paid = 0
      payments.each{|r| paid += r.amount if r.org_id == e.org_id }

      %w{design product tran other}.each do |k|
        amount_k = 0
        e.send("#{k}s").checked.each{|i| amount_k += i.total}
        amount += amount_k * (1 + e.send("#{k}_rate").to_f)
      end
      if amount > 0
        lst << {:org=>e.org,:amount=>amount,:paid=>paid,:balance=>amount-paid}
      end
    end
    
    amount = 0
    paid = 0
    
    payments.each{|r| paid += r.amount if r.org_id == org_id}

    %w{design product tran other}.each do |k|
      amount_k = 0
      send("#{k}s").each{|i| amount_k += i.total}
      amount += amount_k * (1 + send("#{k}_rate").to_f)
    end

    if amount > 0
      lst << {:org=>org,:amount=>amount,:paid=>paid,:balance=>amount-paid}
    end
    return lst
  end
end
