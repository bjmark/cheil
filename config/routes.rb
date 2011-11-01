# encoding: utf-8
Cheil::Application.routes.draw do

  resources :vendor_orgs

  resources :cheil_orgs

  resources :rpm_orgs

  resources :items

  resources :brief_vendors

  resources :brief_comments

  resources :briefs

  resources :orgs

  controller :users do
    get 'users/login'=>:login,:as=>'users_login'
    post 'users/login'=>:check,:as=>'users_check'
    delete 'users/logout'=>:logout,:as=>'users_logout'
  end

  resources :users

  controller :admin_users do
    get 'admin_users/login'=>:login,:as=>'admin_users_login'
    post 'admin_users/login'=>:check,:as=>'admin_users_check'
    delete 'admin_users/logout'=>:logout,:as=>'admin_users_logout'
  end

  resources :admin_users

  controller :rpm do
    #对brief的操作
    #index
    get 'rpm/briefs'=>:briefs,:as=>'rpm_briefs'

    #new
    get 'rpm/briefs/new'=>:new_brief,:as=>'rpm_new_brief'
    
    #create
    post 'rpm/briefs'=>:create_brief,:as=>'rpm_create_brief'
    
    #show
    get 'rpm/briefs/:id'=>:show_brief,:as=>'rpm_show_brief'
    
    #send
    post 'rpm/briefs/:id/send'=>:send_brief,:as=>'rpm_send_brief'
    
    #edit
    get 'rpm/briefs/:id/edit'=>:edit_brief,:as=>'rpm_edit_brief'
    
    #update
    put 'rpm/briefs/:id'=>:update_brief,:as=>'rpm_update_brief'
    
    #delete
    delete 'rpm/briefs/:id'=>:delete_brief,:as=>'rpm_delete_brief'

    #对item的操作
    
    #new item
    get 'rpm/briefs/:brief_id/items/new/:kind'=>:new_item,:as=>'rpm_new_item'

    #create
    post 'rpm/briefs/:brief_id/items'=>:create_item,:as=>'rpm_create_item'

    #edit
    get 'rpm/items/:id/edit'=>:edit_item,:as=>'rpm_edit_item'

    #update
    put 'rpm/items/:id'=>:update_item,:as=>'rpm_update_item'

    #destroy
    delete 'rpm/items/:id' => :destroy_item,:as=>'rpm_destroy_item'

    #对brief_comment的操作
    get 'rpm/briefs/:brief_id/comments/new'=>:new_brief_comment,
      :as=>'rpm_new_brief_comment'

    post 'rpm/briefs/:brief_id/comments'=>:create_brief_comment,
      :as=>'rpm_create_brief_comment'
    
    delete 'rpm/brief/comments/:id' => :destroy_brief_comment,
      :as=>'rpm_destroy_brief_comment'

    #attach
    get 'rpm/briefs/:brief_id/attaches/new' => :new_brief_attach,
      :as => 'rpm_new_brief_attach'
    
    get 'rpm/briefs/:brief_id/attaches/:attach_id/edit' => :edit_brief_attach,
      :as => 'rpm_edit_brief_attach'

    post 'rpm/briefs/:brief_id/attaches' => :create_brief_attach,
      :as => 'rpm_create_brief_attach'

    put 'rpm/briefs/:brief_id/attaches/:attach_id' => :update_brief_attach,
      :as => 'rpm_update_brief_attach'

    delete 'rpm/briefs/:brief_id/attaches/:attach_id' => :destroy_brief_attach,
      :as => 'rpm_destroy_brief_attach'

    get 'rpm/briefs/:brief_id/attaches/:attach_id/download' => :download_brief_attach,
      :as => 'rpm_download_brief_attach'
  end

  controller :cheil do
    #brief列表
    get 'cheil/briefs'=>:briefs,:as=>'cheil_briefs'

    #显示单个brief
    get 'cheil/briefs/:id'=>:show_brief,:as=>'cheil_show_brief'

    #创建brief评论
    post 'cheil/briefs/:brief_id/comment'=>:create_brief_comment,
      :as=>'cheil_create_brief_comment'

    #删除一条brief评论
    delete 'cheil/brief/comment/:id' => :destroy_brief_comment,
      :as=>'cheil_destroy_brief_comment'

    #给brief选择vendor
    get 'cheil/briefs/:id/vendors'=>:sel_brief_vendor,:as=>'cheil_sel_brief_vendor'

    #给brief指定vendor
    post 'cheil/briefs/:brief_id/vendors'=>:add_brief_vendor,
      :as=>'cheil_add_brief_vendor'

    #取消一个指定给brief的vendor
    delete 'cheil/briefs/:brief_id/vendors/:vendor_id' => :del_brief_vendor,
      :as=>'cheil_del_brief_vendor'

    #显示brief子项目，指派给指定vendor
    get 'cheil/briefs/:brief_id/vendors/:vendor_id/items'=>:brief_vendor_items,
      :as=>'cheil_brief_vendor_items'

    #指派一条item给vendor
    post 'cheil/briefs/:brief_id/vendors/:vendor_id/items/:item_id'=>:brief_vendor_add_item,
      :as=>'cheil_brief_vendor_add_item'

    #取消一条指派给vendor的item
    delete 'cheil/briefs/:brief_id/vendors/:vendor_id/items/:item_id'=>:brief_vendor_del_item,
      :as=>'cheil_brief_vendor_del_item'

    #显示某个brief的某个vendor的方案
    get 'cheil/briefs/:brief_id/vendors/:vendor_id/solution'=>:brief_vendor_solution,
      :as=>'cheil_brief_vendor_solution'
  end

  controller :vendor do
    #brief列表
    get 'vendor/briefs'=>:briefs,:as=>'vendor_briefs'

    #显示单个brief
    get 'vendor/briefs/:id'=>:show_brief,:as=>'vendor_show_brief'

    get 'vendor/briefs/:brief_id/items/:item_id/price/edit' =>:item_edit_price,
      :as=>'vendor_item_edit_price'

    put 'vendor/briefs/:brief_id/items/:item_id/price/update' =>:item_update_price,
      :as=>'vendor_item_update_price'

    get 'vendor/briefs/:brief_id/items/new/(:kind)' => :item_new,
      :as=>'vendor_item_new'

    get 'vendor/briefs/:brief_id/items/:item_id/edit' => :item_edit,
      :as=>'vendor_item_edit'

    put 'vendor/briefs/:brief_id/items/:item_id' => :item_update,
      :as=>'vendor_item_update'

    delete 'vendor/briefs/:brief_id/items/:item_id' => :item_del,
      :as=>'vendor_item_del'

    post 'vendor/briefs/:brief_id/items/(:kind)' => :item_create,
      :as=>'vendor_item_create'
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
