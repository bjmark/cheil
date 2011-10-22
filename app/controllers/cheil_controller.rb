class CheilController < ApplicationController
  before_filter :cheil_authorize

  #get 'cheil/briefs'
  def briefs
    @briefs = Brief.order('id desc').find_all_by_send_to_cheil('y')

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  #get 'cheil/briefs/:id'
  def show_brief
    @brief = Brief.find(params[:id])
    @brief_comment = BriefComment.new

    org_ids = @brief.brief_vendors.collect{|e| e.org_id}
    org_ids = org_ids.join(',')
    @vendors = Org.where("id in (#{org_ids}) AND role = 'vendor'").all

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @brief }
    end
  end

  #post 'cheil/briefs/:brief_id/comment'
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

  #get 'cheil/briefs/:id/vendors'
  def sel_brief_vendor
    #已被选中的vendors
    @brief = Brief.find(params[:id])
    bv = BriefVendor.find_all_by_brief_id(params[:id])
    #所有org去除已被选中的vendor
    @vendors = Org.find_all_by_role('vendor').reject do |e| 
      bv.find{|t| t.org_id == e.id}
    end
  end

  #post 'cheil/briefs/:brief_id/vendors'
  def add_brief_vendor
    @brief = Brief.find(params[:brief_id])
    vendor_ids = []
    params.each {|k,v| vendor_ids << v if k=~/vendor\d+/}
    vendor_ids.each do |org_id|
      a = BriefVendor.new
      a.brief_id = @brief.id
      a.org_id = org_id
      a.save
    end

    redirect_to(cheil_show_brief_url(@brief)) 
  end

  #delete 'cheil/briefs/:brief_id/vendors/:vendor_id' => :del_brief_vendor,
  def del_brief_vendor
    BriefVendor.delete_all(['brief_id=? and org_id=?',
                           params[:brief_id],params[:vendor_id]])
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

