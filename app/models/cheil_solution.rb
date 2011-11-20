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
    total_hash = {}
    sum_all = 0

    kinds.each do |k|
      sum = 0 
      send("checked_#{k}s".to_sym).each{|e| sum += e.total}
      send("#{k}s".to_sym).each{|e| sum += e.total}
      total_hash[k] = sum
      sum_all += sum
    end

    total_hash[:all] = sum_all
    return total_hash
  end

end
