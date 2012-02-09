#encoding=utf-8
class BriefsController < ApplicationController
  before_filter :cur_user , :check_right

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
      render 'index_rpm'
    when CheilOrg,VendorOrg
      render 'index_cheil'
    end
  end

  def not_send
    @briefs = @cur_user.org.briefs.where(:cheil_id=>0).page(params[:page])
  end

  def search_cond
    case @cur_user.org
    when RpmOrg
      render 'search_cond_rpm'
    when CheilOrg,VendorOrg
      render 'search_cond_cheil'
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
      render 'search_res_rpm'
    when CheilOrg,VendorOrg
      render 'search_res_cheil'
    end
  end

  # GET /briefs/1
  def show
    @brief = Brief.find(params[:id])
    #check read right
    invalid_op unless @brief.op_right.check('self',@cur_user.org_id,'read')
    #readed by current user
    @brief.op.read_by(@cur_user.id)
    
    @attaches = @brief.attaches.find_all{|e| e.op_right.check('self',@cur_user.org_id,'read') }

    case @cur_user.org
    when RpmOrg
      render 'show_rpm'
    when CheilOrg
      render 'show_cheil'
    when VendorOrg
      @solution = @brief.solutions.find_by_org_id(@cur_user.org_id)
      render 'show_vendor'
    end
  end

  # GET /briefs/new
  def new
    @brief = Brief.new
  end

  # GET /briefs/1/edit
  def edit
    @brief = Brief.find(params[:id])
    @brief.check_edit_right(@cur_user.org_id)
    @back = brief_path(@brief)
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
    @brief = Brief.new(attr_filter(params[:brief]))
    @brief.rpm_id = @cur_user.org_id
    @brief.user_id = @cur_user.id

    @brief.op_right.set('self',@cur_user.org_id,'read','update','delete')
    @brief.op_right.set('attach',@cur_user.org_id,'read','update')
    @brief.op_right.set('item',@cur_user.org_id,'read','update')
    @brief.op_right.set('comment',@cur_user.org_id,'read','update')

    if @brief.op.save_by(@cur_user.id)
      redirect_to briefs_path, notice: 'Brief was successfully created.' 
    else
      render action: "new" 
    end
  end

  # PUT /briefs/1
  # PUT /briefs/1.json
  def update
    @brief = Brief.find(params[:id])
    @brief.check_edit_right(@cur_user.org_id)
    
    attr_hash = attr_filter(params[:brief])
    attr_hash['read_by'] = @cur_user.id.to_s
    attr_hash['updated_at'] = Time.now

    if @brief.update_attributes(attr_hash)
      redirect_to @brief, notice: 'Brief was successfully updated.' 
    else
      @back = brief_path(@brief)
      render action: "edit" 
    end
  end

  # DELETE /briefs/1
  # DELETE /briefs/1.json
  def destroy
    @brief = Brief.find(params[:id])
    @brief.check_destroy_right(@cur_user.org_id)
    @brief.destroy
    redirect_to briefs_url,notice: 'Brief was successfully deleted.' 
  end

  #put /briefs/1/send_to_cheil
  def send_to_cheil
    brief = Brief.find(params[:id])
    raise SecurityError if brief.rpm_id != @cur_user.org_id
    brief.send_to_cheil!

    brief.op_right.add('self',brief.cheil_id,'read','update')
    brief.op_right.set('attach',brief.cheil_id,'read','update')
    brief.op_right.set('item',brief.cheil_id,'read','update')
    brief.op_right.set('comment',brief.cheil_id,'read','update')
    brief.save

    redirect_to(brief_path(brief),:notice=>'成功发送到cheil') 
  end

  def cancel_cancel
    cancel{'n'}
  end

  def cancel
    @brief = Brief.find(params[:id])
    @brief.check_edit_right(@cur_user.org_id)
    if block_given?
      @brief.cancel = yield
    else
      @brief.cancel = 'y'
    end
    @brief.op.save_by(@cur_user.id)
    redirect_to(brief_path(@brief)) 
  end
end
