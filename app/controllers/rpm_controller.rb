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
  before_filter :cur_user,:authorize

  def authorize
    unless @cur_user.org.instance_of?(RpmOrg)
      redirect_to users_login_url
    end
  end

  #get 'rpm/briefs'=>:briefs,:as=>'rpm_briefs'
  def briefs
    @briefs = @cur_user.rpm_org.
      briefs.paginate(:page => params[:page])
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
    return true if brief.rpm_id == user.org_id
    invalid_op
  end

  #get 'rpm/briefs/:id'=>:show_brief,:as=>'rpm_show_brief'
  def show_brief
    @brief = Brief.find(params[:id])
    
    brief_can_read?(@brief,@cur_user)

    @brief_creator = @brief.user.name

    @brief_attaches = @brief.attaches
    
    @brief_items = @brief.items
    @brief_designs = @brief.designs
    @brief_products = @brief.products

    @comments = @brief.comments
    @back = rpm_show_brief_path(@brief)
  end

  def item_can_modify?(item,user)
    item.brief.rpm_id == user.org_id
  end

  #get 'rpm/briefs/:brief_id/items/new/:kind'=>:new_item,:as=>'rpm_new_item'
  def new_item
    @brief = Brief.find(params[:brief_id])
    brief_can_read?(@brief,@cur_user)
    @item = @brief.items.new
    @item.kind = params[:kind]
    @action_to = rpm_create_item_path(@brief)
  end

  #post 'rpm/briefs/:brief_id/items'=>:create_item,:as=>'rpm_create_item'
  def create_item
    @brief = Brief.find(params[:brief_id])
    brief_can_read?(@brief,@cur_user)
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

  #get 'rpm/briefs/:brief_id/attaches/:attach_id/edit' => :edit_brief_attach,
  #  :as => 'rpm_edit_brief_attach'
  def edit_brief_attach
    @brief = Brief.find(params[:brief_id])
    brief_can_read?(@brief,@cur_user)

    @brief_attach = @brief.attaches.find(params[:attach_id])
    @path = rpm_update_brief_attach_path(@brief,@brief_attach)
  end

  #post 'rpm/briefs/:brief_id/attaches' => :create_brief_attach,
  #  :as => 'rpm_create_brief_attach'
  def create_brief_attach
    @brief = Brief.find(params[:brief_id])
    brief_can_read?(@brief,@cur_user)

    attach = BriefAttach.new(params[:brief_attach])
    attach.brief_id = @brief.id

    if attach.save
      redirect_to rpm_show_brief_path(@brief)
    else
      render :action => 'new_brief_attach'
    end
  end

  #put 'rpm/briefs/:brief_id/attaches/:attach_id' => :update_brief_attach,
  #  :as => 'rpm_update_brief_attach'
  def update_brief_attach
    @brief = Brief.find(params[:brief_id])
    brief_can_read?(@brief,@cur_user)

    @brief_attach = @brief.attaches.find(params[:attach_id])
    if @brief_attach.update_attributes(params[:brief_attach])
      redirect_to rpm_show_brief_path(@brief)
    else
      @path = rpm_update_brief_attach_path(@brief,@brief_attach)
      render :action => 'edit_brief_attach'
    end
  end
  #delete 'rpm/briefs/:brief_id/attaches/:attach_id' => :destroy_brief_attach,
  #   :as => 'rpm_destroy_brief_attach'
  def destroy_brief_attach
    @brief = Brief.find(params[:brief_id])
    brief_can_read?(@brief,@cur_user)

    attach = @brief.attaches.find(params[:attach_id])
    attach.destroy

    redirect_to rpm_show_brief_path(@brief)
  end

  #get 'rpm/briefs/:brief_id/attaches/:attach_id/download' => :download_brief_attach,
  #   :as => 'rpm_download_brief_attach'
  def download_brief_attach
    @brief = Brief.find(params[:brief_id])
    brief_can_read?(@brief,@cur_user)

    attach = @brief.attaches.find(params[:attach_id])

    send_file attach.attach.path,
      :filename => attach.attach_file_name,
      :content_type => attach.attach_content_type
  end
end

