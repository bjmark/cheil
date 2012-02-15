#encoding=utf-8
class BriefsController < ApplicationController
  before_filter :cur_user 

  def check_right
    share = [:index,:show,:search_cond,:search_res]
    rpm_cheil = [:edit,:update] 

    rpm =[:new,:create,:destroy,:send_to_cheil,:not_send,:cancel,:cancel_cancel] + 
      rpm_cheil + share

    cheil = rpm_cheil + share
    vendor = share

    ok=case @cur_user.org
       when RpmOrg then rpm.include?(params[:action].to_sym)
       when CheilOrg then cheil.include?(params[:action].to_sym)
       when VendorOrg then vendor.include?(params[:action].to_sym)
       else false
       end
    ok or (raise SecurityError) 
  end

  # GET /briefs
  def index
    @briefs = @cur_user.org.briefs.page(params[:page])
    case @cur_user.org
    when RpmOrg
      @nav = :rpm
    when CheilOrg,VendorOrg
      @nav = :cheil
    end
  end

  def not_send
    @briefs = @cur_user.org.briefs.where(:cheil_id=>0).page(params[:page])
  end

  def search_cond
    case @cur_user.org
    when RpmOrg
      @nav = :rpm
    when CheilOrg,VendorOrg
      @nav = :cheil
    end
  end

  def str_to_date(s)
    return nil if s.blank?
    return nil if (a = s.split('-')).length != 3
    ymd = a.collect{|e| e.to_i}
    Date.new(ymd[0],ymd[1],ymd[2])
  end

  def search_res
    @briefs = @cur_user.org.briefs.search_name(params[:name]).
      deadline_great_than(str_to_date(params[:deadline1])).
      deadline_less_than(str_to_date(params[:deadline2])).
      create_date_great_than(str_to_date(params[:create_date1])).
      create_date_less_than(str_to_date(params[:create_date2])).
      update_date_great_than(str_to_date(params[:update_date1])).
      update_date_less_than(str_to_date(params[:update_date2])).
      status(params[:status]).
      page(params[:page])
    
    case @cur_user.org
    when RpmOrg
      @nav = :rpm
    when CheilOrg,VendorOrg
      @nav = :cheil
    end
  end

  # GET /briefs/1
  def show
    @brief = Brief.find(params[:id])
    
    #check read right
    invalid_op unless @brief.op_right.check('self',@cur_user.org_id,'read')
    
    #del my org_id from notice 
    @brief.op_notice.del(@cur_user.org_id)
    @brief.save
    
    if @brief.op_right.check('attach',@cur_user.org_id,'read')
      #get those attaches i can read
      @attaches = @brief.attaches.find_all{|e| e.op_right.check('self',@cur_user.org_id,'read') }
    end

    if @brief.op_right.check('item',@cur_user.org_id,'read')
      #get those items i can read
      @items = @brief.items.find_all{|e| e.op_right.check('self',@cur_user.org_id,'read') }
      #@designs,@products is prepare for display
      @designs = @brief.designs.find_all{|e| e.op_right.check('self',@cur_user.org_id,'read') }
      @products = @brief.products.find_all{|e| e.op_right.check('self',@cur_user.org_id,'read') }
    end

    if @brief.op_right.check('comment',@cur_user.org_id,'read')
      @comments = @brief.comments
    end

    case @cur_user.org
    when RpmOrg
      @nav_link = :rpm
    when CheilOrg
      @nav_link = :cheil
    when VendorOrg
      @solution = @brief.vendor_solutions.where(:org_id=>@cur_user.org_id).first
      @nav_link = :vendor
    end
  end

  # GET /briefs/new
  def new
    @brief = Brief.new
  end

  # GET /briefs/1/edit
  def edit
    @brief = Brief.find(params[:id])
    invalid_op unless @brief.op_right.check('self',@cur_user.org_id,'update')
  end

  def attr_filter(attr_hash)
    attr_valid = {}
    attr_name = %w{name req deadline(1i) deadline(2i) deadline(3i)}
    if attr_hash
      attr_name.each{|e|attr_valid[e] = attr_hash[e] if attr_hash[e]}
    end
    return attr_valid
  end

  # POST /briefs
  def create
    invalid_op unless @cur_user.org.instance_of?(RpmOrg)

    @brief = Brief.new(attr_filter(params[:brief]))
    @brief.rpm_id = @cur_user.org_id
    @brief.user_id = @cur_user.id

    @brief.op_right.add('self',@cur_user.org_id,'read','update','delete')
    @brief.op_right.add('attach',@cur_user.org_id,'read','update')
    @brief.op_right.add('item',@cur_user.org_id,'read','update')
    @brief.op_right.add('comment',@cur_user.org_id,'read','update')

    if @brief.save
      redirect_to brief_path(@brief) 
    else
      render action: "new" 
    end
  end

  # PUT /briefs/1
  # PUT /briefs/1.json
  def update
    @brief = Brief.find(params[:id])
    invalid_op unless @brief.op_right.check('self',@cur_user.org_id,'update')

    attr_hash = attr_filter(params[:brief])
    attr_hash['updated_at'] = Time.now

    if @brief.update_attributes(attr_hash)
      @brief.op_notice.changed_by(@cur_user.org_id)
      @brief.save
      redirect_to @brief, notice: 'Brief was successfully updated.' 
    else
      render action: "edit" 
    end
  end

  # DELETE /briefs/1
  # DELETE /briefs/1.json
  def destroy
    brief = Brief.find(params[:id])

    invalid_op unless brief.op_right.check('self',@cur_user.org_id,'delete')
    
    brief.destroy
    redirect_to briefs_url,notice: 'Brief was successfully deleted.' 
  end

  #put /briefs/1/send_to_cheil
  def send_to_cheil
    brief = Brief.find(params[:id])
    invalid_op if brief.rpm_id != @cur_user.org_id

    brief.cheil_id = brief.rpm_org.cheil_org.id
    brief.status = 1 #方案中
    #brief.send_to_cheil!

    brief.op_right.add('self',brief.cheil_id,'read','update')
    brief.op_right.add('attach',brief.cheil_id,'read','update')
    brief.op_right.add('item',brief.cheil_id,'read','update')
    brief.op_right.add('comment',brief.cheil_id,'read','update')
    brief.op_right.add('vendor_solution',brief.cheil_id,'read','update')
    brief.op_right.add('cheil_solution',brief.cheil_id,'read')
    brief.op_notice.add(brief.cheil_id)
    brief.save

    #creat a cheil solution
    brief.create_cheil_solution(:org_id=>brief.cheil_id)
    
    brief.attaches.each do |e| 
      e.op_right.add('self',brief.cheil_id,'read','update','delete')
      e.op_notice.add(brief.cheil_id)
      e.save
    end

    brief.items.each do |e| 
      e.op_right.add('self',brief.cheil_id,'read','update','delete')
      e.op_notice.add(brief.cheil_id)
      e.save
    end

    brief.comments.each do |e|
      e.op_right.add('self',brief.cheil_id,'read')
      e.op_notice.add(brief.cheil_id)
      e.save
    end

    redirect_to(brief_path(brief),:notice=>'成功发送到cheil') 
  end

  def cancel_cancel
    cancel{'n'}
  end

  def cancel
    brief = Brief.find(params[:id])
    invalid_op if brief.rpm_id != @cur_user.org_id

    if block_given?
      brief.cancel = yield
    else
      brief.cancel = 'y'
    end
    brief.op_notice.changed_by(@cur_user.org_id)
    brief.save

    redirect_to(brief_path(brief)) 
  end
end
