# encoding: utf-8

#录入多条design和product
class FakeBrief
  def initialize(h=nil)
    if h.nil?
      @hash={'name'=>''}
      (1..5).each do |n| 
        @hash["design#{n}_name"]=''
        @hash["design#{n}_quantity"]=''

        @hash["product#{n}_name"]=''
        @hash["product#{n}_quantity"]=''
      end
    else
      @hash = Hash.new
      h.each {|k,v| @hash[k.to_s] = v.to_s}
    end 
  end

  def get_hash
    @hash
  end

  def method_missing(method_sym, *arguments, &block)
    # the first argument is a Symbol, so you need to_s it if you want to pattern match
    @hash[method_sym.to_s]
  end

  def add_5_design
    add_5('design')
  end

  def add_5_product
    add_5('product')
  end

  def add_5(kind)
    n=1
    n +=1 while @hash["#{kind}#{n}_name"]
    (n..n+4).each do |n| 
      @hash["#{kind}#{n}_name"]=''
      @hash["#{kind}#{n}_quantity"]=''
    end
  end

  def get_brief
    h = Hash.new
    h['name'] = @hash['name']
    return h
  end

  def get_items
    items = Array.new
    @hash.each do |k,v|
      if k.to_s =~ /^design\d+_name/
        items << {
        'name' => v,
        'quantity' => @hash[k.to_s.gsub(/name/,'quantity')], 
        'kind' => 'design'
      }
      end

      if k.to_s =~ /^product\d+_name/
        items << {
        'name' => v,
        'quantity' => @hash[k.to_s.gsub(/name/,'quantity')], 
        'kind' => 'product'
      }
      end
    end
    return items.reject{|e| e['name'].empty? and e['quantity'].empty?}
  end
end

#包含rpm的所有操作
class RpmController < ApplicationController
  #检查是否login
  before_filter :rpm_authorize

  #get 'rpm/briefs'=>:briefs,:as=>'rpm_briefs'
  def briefs
    @briefs = @cur_user.rpm_org.
      briefs.paginate(:page => params[:page]).order('id DESC')
    #@briefs = Brief.order('id desc').find_all_by_org_id(@cur_user.org_id)
  end

  #get 'rpm/briefs/new'=>:new_brief,:as=>'rpm_new_brief'
  def new_brief
    @brief = Brief.new
    @action_to = rpm_create_brief_path
  end

  #post 'rpm/briefs'=>:create_brief,:as=>'rpm_create_brief'
  def create_brief
    @brief = Brief.new(params['brief'])
    @brief.rpm_id = @cur_user.org_id
    @brief.user_id = @cur_user.id

    if @brief.save
      redirect_to rpm_show_brief_path(@brief)
    else
      render action: 'new_brief'
    end
  end

  #用户是否有权看brief
  def brief_can_read?(brief,user)
    brief.rpm_id == user.org_id
  end
  #用户是否有权改brief
  def brief_can_modify?(brief,user)
    brief.rpm_id == user.org_id
  end

  #get 'rpm/briefs/:id'=>:show_brief,:as=>'rpm_show_brief'
  def show_brief
    @brief = Brief.find(params[:id])
    invalid_op unless brief_can_read?(@brief,@cur_user)
    @brief_comment = BriefComment.new

    @brief_designs = @brief.designs
    @brief_products = @brief.products
  end

  #post 'rpm/briefs/:id/send'=>:send_brief,:as=>'rpm_send_brief'
  def send_brief
    @brief = Brief.find(params[:id])
    invalid_op unless brief_can_read?(@brief,@cur_user)
    @brief.send_to_cheil!
    redirect_to(rpm_show_brief_path(@brief),:notice=>'成功发送到cheil') 
  end

  #get 'rpm/briefs/:id/edit'=>:edit_brief,:as=>'rpm_edit_brief'
  def edit_brief
    @brief = Brief.find(params[:id])
    invalid_op unless brief_can_modify?(@brief,@cur_user)
    @action_to = rpm_update_brief_path
  end

  #put 'rpm/briefs/:id'=>:update_brief,:as=>'rpm_update_brief'
  def update_brief
    @brief = Brief.find(params[:id])
    invalid_op unless brief_can_modify?(@brief,@cur_user)

    respond_to do |format|
      if @brief.update_attributes(params[:brief])
        format.html { redirect_to(rpm_show_brief_path(@brief)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  #delete 'rpm/briefs/:id'
  def delete_brief
    @brief = Brief.find(params[:id])
    invalid_op unless brief_can_modify?(@brief,@cur_user)
    
    #删除关联的design,product等子项
    Item.delete_all("brief_id = #{@brief.id}")
    
    #删除所有指派给vendor的子项
    vendor_ids = @brief.brief_vendor_ids
    vendor_ids = vendor_ids.join(',')
    Item.delete_all("brief_vendor_id in (#{vendor_ids})")
    
    #删除vendors指派
    BriefVendor.delete_all("brief_id = #{@brief.id}")

    @brief.destroy
    respond_to do |format|
      format.html { redirect_to(rpm_briefs_path) }
    end
  end

  def item_can_modify?(item,user)
    item.brief.rpm_id == user.org_id
  end

  #get 'rpm/briefs/:brief_id/items/new/:kind'=>:new_item,:as=>'rpm_new_item'
  def new_item
    @brief = Brief.find(params[:brief_id])
    invalid_op unless brief_can_modify?(@brief,@cur_user)
    @item = @brief.items.new
    @item.kind = params[:kind]
    @action_to = rpm_create_item_path(@brief)
  end

  #post 'rpm/briefs/:brief_id/items'=>:create_item,:as=>'rpm_create_item'
  def create_item
    @brief = Brief.find(params[:brief_id])
    invalid_op unless brief_can_modify?(@brief,@cur_user)
    @brief.items.create(params[:item]) 

    respond_to do |format|
      format.html { redirect_to(rpm_show_brief_url(@brief)) }
    end
  end

  #get 'rpm/items/:id/edit'=>:edit_item,:as=>'rpm_edit_item'
  def edit_item
    @item = Item.find(params[:id])
    invalid_op unless item_can_modify?(@item,@cur_user)
    @action_to = rpm_update_item_path(@item) 
  end

  #put 'rpm/items/:id'=>:update_item,:as=>'rpm_update_item'
  def update_item
    @item = Item.find(params[:id])
    invalid_op unless item_can_modify?(@item,@cur_user)
    
    field = params[:item]
    @item.name = field[:name]
    @item.quantity = field[:quantity]
    @item.kind = field[:kind]

    respond_to do |format|
      if @item.save
        format.html { redirect_to(rpm_show_brief_url(@item.brief)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  #delete 'rpm/items/:id' => :destroy_item,:as=>'rpm_destroy_item'
  def destroy_item
    @item = Item.find(params[:id])
    invalid_op unless item_can_modify?(@item,@cur_user)
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(rpm_show_brief_url(@item.brief)) }
    end
  end

  #post 'rpm/briefs/:brief_id/comments'
  def create_brief_comment
    @brief = Brief.find(params[:brief_id])
    invalid_op unless brief_can_modify?(@brief,@cur_user)

    attrs = Hash.new
    params[:brief_comment].each{|k,v| attrs[k]=v}
    attrs[:user_id] = @cur_user.id

    @brief.comments.create!(attrs)

    respond_to do |format|
      format.html { redirect_to(rpm_show_brief_url(@brief)) }
    end
  end

  # delete 'rpm/brief/comments/:id'
  def destroy_brief_comment
    @brief_comment = BriefComment.find(params[:id])
    @brief_comment.destroy if @brief_comment.user_id == @cur_user.id

    respond_to do |format|
      format.html { redirect_to(rpm_show_brief_url(@brief_comment.brief_id)) }
    end
  end
end

