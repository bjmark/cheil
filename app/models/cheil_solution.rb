#encoding=utf-8
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

  def checked_designs(reload=false)
    @checked_designs = nil if reload
    return @checked_designs if @checked_designs

    @checked_designs = []
    brief.vendor_solutions.each do |vs|
      @checked_designs += vs.designs.find_all_by_checked('y')
    end

    return @checked_designs
  end
  
  def checked_products(reload=false)
    @checked_products = nil if reload
    return @checked_products if @checked_products

    @checked_products = []
    brief.vendor_solutions.each do |vs|
      @checked_products += vs.products.find_all_by_checked('y')
    end

    return @checked_products
  end

  def checked_trans(reload=false)
    @checked_trans = nil if reload
    return @checked_trans if @checked_trans

    @checked_trans = []
    brief.vendor_solutions.each do |vs|
      @checked_trans += vs.trans.find_all_by_checked('y')
    end

    return @checked_trans
  end

  def checked_others(reload=false)
    @checked_others = nil if reload
    return @checked_others if @checked_others

    @checked_others = []
    brief.vendor_solutions.each do |vs|
      @checked_others += vs.others.find_all_by_checked('y')
    end

    return @checked_others
  end

  def checked_items
    checked_designs + checked_products + checked_trans + checked_others
  end

  def total
    kinds = [:design,:product,:tran,:other]
    sum_all = 0
    sum_all_r = 0
    total_hash = {}
    kinds.each do |k|
      total_hash[k]=[]
      brief.vendor_solutions.each do |vs|
        sum = 0 
        vs.send("#{k}s").where(:checked=>'y').collect{|e| sum += e.total}
        if sum > 0
          total_hash[k] << 
          {:name=>vs.org.name,
            :sum=>sum,
            :rate=>(rate=vs.send("#{k}_rate")),
            :sum_r=>(sum_r=sum*(1+rate.to_f))}
          sum_all += sum
          sum_all_r += sum_r
        end
      end
      sum = 0
      send("#{k}s").collect{|e| sum += e.total}
      if sum > 0
        total_hash[k] << 
        {:name=>org.name,
          :sum=>sum,
          :rate=>(rate=send("#{k}_rate")),
          :sum_r=>(sum_r=sum*(1+rate.to_f))}
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

end
