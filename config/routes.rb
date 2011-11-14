# encoding: utf-8
Cheil::Application.routes.draw do

  resource :session , :only=>[:new,:create,:destroy]
  
  resources :attaches do
    member do 
      get :download
    end
  end

  resources :vendor_orgs

  resources :cheil_orgs

  resources :rpm_orgs

  resources :brief_vendors

  resources :briefs do
    member do
      put :send_to_cheil
    end
    resources :comments , :only=>[:new,:create,:destroy]
    resources :attaches,:except=>[:show,:index] do  
      member do 
        get :download
      end
    end

    resources :items 

    resources :solutions,:only=>[:index,:show,:create,:destroy] do 
      collection do
        get :sel_vendor
      end
    end
  end

  resource :solutions do
    resources :comments , :only=>[:new,:create,:destroy]
    resources :attaches,:except=>[:show,:index] do  
      member do 
        get :download
      end
    end
  end

  controller :items do 
    get 'solutions/:solution_id/items/change' => :change_solution_items,
      :as=>'change_solution_items'
    post 'solutions/:solution_id/items/:id' => :create,
      :as=>'solution_item'
    delete 'solutions/:solution_id/items/:id' => :destroy,
  end

  resources :orgs

  resources :users
  resources :admin_users


  controller :cheil do
    #brief列表
    get 'cheil/briefs'=>:briefs,:as=>'cheil_briefs'

    #显示单个brief
    get 'cheil/briefs/:id'=>:show_brief,:as=>'cheil_show_brief'

    #下载附件
    get 'cheil/briefs/:brief_id/attaches/:attach_id/download' => :download_brief_attach,
      :as => 'cheil_download_brief_attach'

    get 'cheil/briefs/:brief_id/comments/new'=>:new_brief_comment,
      :as=>'cheil_new_brief_comment'

    #创建brief评论
    post 'cheil/briefs/:brief_id/comments'=>:create_brief_comment,
      :as=>'cheil_create_brief_comment'

    #删除一条brief评论
    delete 'cheil/brief/comments/:id' => :destroy_brief_comment,
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
