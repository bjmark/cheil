class CheilController < ApplicationController
  before_filter :cheil_authorize

  def brief_can_read?(brief,user)
    return true if brief.cheil_id == user.org_id
    invalid_op
  end
  
  #get 'cheil/briefs'=>:briefs,:as=>'cheil_briefs'
  def briefs
    @briefs = @cur_user.cheil_org.
      briefs.paginate(:page => params[:page])
  end

  #get 'cheil/briefs/:id'=>:show_brief,:as=>'cheil_show_brief'
  def show_brief
    @brief = Brief.find(params[:id])
    @brief_creator = @brief.user.name

    @brief_attaches = @brief.attaches

    @brief_items = @brief.items
    @brief_designs = @brief.designs
    @brief_products = @brief.products

    org_ids = @brief.brief_vendors.collect{|e| e.org_id}
    if org_ids.empty?
      @vendors = []
    else
      org_ids = org_ids.join(',')
      @vendors = VendorOrg.where("id in (#{org_ids})").all
    end
  end

  #get 'cheil/briefs/:brief_id/attaches/:attach_id/download' => :download_brief_attach,
  #  :as => 'cheil_download_brief_attach'
  def download_brief_attach
    @brief = Brief.find(params[:brief_id])
    brief_can_read?(@brief,@cur_user)

    attach = @brief.attaches.find(params[:attach_id])

    send_file attach.attach.path,
      :filename => attach.attach_file_name,
      :content_type => attach.attach_content_type
  end

  #get 'cheil/briefs/:brief_id/comments/new'=>:new_brief_comment,
  #  :as=>'cheil_new_brief_comment'
  def new_brief_comment
    @brief = Brief.find(params[:brief_id])
    brief_can_read?(@brief,@cur_user)
    @brief_comment = BriefComment.new
    @path = cheil_create_brief_comment_path(@brief)
  end

  #post 'cheil/briefs/:brief_id/comments'=>:create_brief_comment,
  #  :as=>'cheil_create_brief_comment'
  def create_brief_comment
    @brief = Brief.find(params[:brief_id])
    bc = BriefComment.new(params[:brief_comment]) do |r|
      r.user = @cur_user
    end
    @brief.comments << bc 
    respond_to do |format|
      format.html { redirect_to(cheil_show_brief_url(@brief)) }
    end
  end

  #delete 'cheil/brief/comment/:id' 
  def destroy_brief_comment
    @brief_comment = BriefComment.find(params[:id])
    @brief_comment.destroy if @cur_user.id == @brief_comment.user_id

    respond_to do |format|
      format.html { redirect_to(cheil_show_brief_url(@brief_comment.brief_id)) }
      format.xml  { head :ok }
    end
  end

  #get 'cheil/briefs/:id/vendors'=>:sel_brief_vendor,:as=>'cheil_sel_brief_vendor'
  def sel_brief_vendor
    #已被选中的vendors
    @brief = Brief.find(params[:id])
    bv = @brief.brief_vendors
    #所有org去除已被选中的vendor
    @vendors = VendorOrg.all.reject do |e| 
      bv.find{|t| t.org_id == e.id}
    end
  end

  #post 'cheil/briefs/:brief_id/vendors'=>:add_brief_vendor,
  #  :as=>'cheil_add_brief_vendor'
  def add_brief_vendor
    @brief = Brief.find(params[:brief_id])
    vendor_ids = []
    params.each {|k,v| vendor_ids << v if k=~/vendor\d+/}
    vendor_ids.each do |org_id|
      @brief.brief_vendors << BriefVendor.new(:org_id=>org_id)
    end

    redirect_to(cheil_show_brief_url(@brief)) 
  end

  #delete 'cheil/briefs/:brief_id/vendors/:vendor_id' => :del_brief_vendor,
  #  :as=>'cheil_del_brief_vendor'
  def del_brief_vendor
    brief = Brief.find(params[:brief_id])
    brief_can_read?(brief,@cur_user)
    brief_vendor = brief.brief_vendors.find_by_org_id(params[:vendor_id])
    brief_vendor.destroy
    redirect_to(cheil_show_brief_url(params[:brief_id])) 
  end

  #get 'cheil/briefs/:brief_id/vendors/:vendor_id/solution'=>:brief_vendor_solution,
  #:as=>'cheil_brief_vendor_solution'
  def brief_vendor_solution
    @vendor = Org.find(params[:vendor_id])
    @brief = Brief.find(params[:brief_id])
    @brief_vendor = @brief.brief_vendors.find_by_org_id(params[:vendor_id])
  end

  #get 'cheil/briefs/:brief_id/vendors/:vendor_id/items'=>:brief_vendor_items,
  #  :as=>'cheil_brief_vendor_items'
  def brief_vendor_items
    @brief = Brief.find(params[:brief_id])
    @vendor = Org.find(params[:vendor_id])
    brief_vendor = BriefVendor.find_by_brief_id_and_org_id(@brief.id,@vendor.id)
    @vendor_items_ids = brief_vendor.items.collect{|e| e.parent_id} 
  end  

  #get post 'cheil/briefs/:brief_id/vendors/:vendor_id/items/:item_id'=>
  #:brief_vendor_add_item,:as=>'cheil_brief_vendor_add_item'
  def brief_vendor_add_item
    brief = Brief.find(params[:brief_id])
    brief_vendor = brief.brief_vendors.find_by_org_id(params[:vendor_id])
    brief_vendor.items << Item.new{|r| r.parent_id = params[:item_id]}

    redirect_to(cheil_brief_vendor_items_path(params[:brief_id],params[:vendor_id])) 
  end

  #get delete 'cheil/briefs/:brief_id/vendors/:vendor_id/items/:item_id'=>
  #:brief_vendor_del_item,:as=>'cheil_brief_vendor_del_item'
  def brief_vendor_del_item
    brief = Brief.find(params[:brief_id])
    brief_vendor = brief.brief_vendors.find_by_org_id(params[:vendor_id])
    item = brief_vendor.items.find_by_parent_id(params[:item_id])

    item.destroy

    redirect_to(cheil_brief_vendor_items_url(params[:brief_id],params[:vendor_id])) 
  end 

  def demo

  end
end

