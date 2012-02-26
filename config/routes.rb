# encoding: utf-8
Cheil::Application.routes.draw do

  resources :logins , :only=>[:index]

  resources :payments

  resources :payers

  resource :session , :only=>[:new,:create,:destroy]
  
  resources :brief_attaches do 
    member do 
      get :download
    end
  end

  resources :solution_attaches do
    member do 
      get :download
      put :check
      put :uncheck
    end
  end

  resources :brief_items do
    collection do 
      get 'new_many'
      post 'create_many'
      get 'edit_many'
      put 'update_many'
    end
  end

  resources :solution_items do 
    member do
      put :check
      put :uncheck

      get :edit_price
      put :update_price
    end
    collection do
      get :edit_price_many
      put :update_price_many
      
      get :new_many
      post :create_many
      
      get :edit_many
      put :update_many
    end
  end

  resources :solution_comments , :only=>[:new,:create,:destroy]
  resources :brief_comments , :only=>[:new,:create,:destroy]

  resources :solutions do
    member do
      get :edit_rate
      put :update_rate
      put :approve
      put :unapprove
      put :send_to_rpm
      put :finish
      put :unfinish
    end
  end

  resources :cheil_solutions do
    member do
      put :approve
      put :unapprove
      put :send_to_rpm
      put :finish
      put :unfinish
      put :set_status
      get :payment
    end
  end

  resources :vendor_solutions do
    member do
      get :edit_rate
      get :pick_brief_items
      put :update_rate
      post :add_brief_item
      delete :del_brief_item
    end
    collection do
      get :new_many
      post:create_many
    end
  end

  resources :vendor_orgs

  resources :cheil_orgs

  resources :rpm_orgs

  resources :briefs do
    member do
      put :send_to_cheil
      put :cancel
      put :cancel_cancel
    end
    collection do 
      get :not_send
      get :search_cond
      get :search_res
    end
  end

  resources :orgs

  resources :users 

  resources :admin_users

  resources :pages , :only=>[:show]
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
  root :to => 'sessions#new'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
