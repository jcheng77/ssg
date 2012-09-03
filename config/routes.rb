Ssg::Application.routes.draw do
  root :to => 'home#index'

  resources :items do
    member do
      get 'add'
      post 'add_tag'
      post 'recommend'
    end
    collection do
      get 'share'
      get 'tagged'
    end
  end

  resources :users do
    member do
      get 'dashboard'
      get 'my_shares'
      get 'my_wishes'
      get 'my_bags'
      get 'friends'
      get 'followers'
      get 'followees'
      get 'select'
      get 'follow'
      get 'unfollow'
      get 'account'
      get 'edit_account'
      put 'update_account'
      get 'edit_preferences'
      put 'update_preferences'
      # resources :categories
      resources :notifications, :only => [:index, :show]
    end

    collection do
      get 'signup'
      get 'recent_notifications'
      get 'all_notifications'
    end
  end

  resources :shares do
    member do
      get 'choose'
      post 'add_to_wish'
      post 'add_to_bag'
    end
  end

  resources :wishes, :only => [:show]
  resources :bags, :only => [:show]

  resources :comments do
    member do
      get 'vote'
    end
  end

  resources :choices
  resources :invitations
  resources :sessions

  match "login" => "sessions#new", :as => :login
  match "logout" => "sessions#destroy", :as => :logout
  match "syncs/:type/new" => "syncs#new", :as => :sync_new
  match "syncs/:type/callback" => "syncs#callback", :as => :sync_callback
  #match "taobao/callback" => "taobao#callback", :as => :taobao_callback
  match "taobao/purchases" => "taobao#purchases", :as => :taobao_purchases
  match "taobao/authorize" => "taobao#authorize", :as => :taobao_auth
  match "tbwishes" => "taobao#favorites"
  match "itemcard" => "items#index2"
  match "usercode" => "users#code"
  match "collect" => "items#collect", :as => :collecter
  #match "user/recent_notification" => "user#recent_notification" , :as => :recent_notification

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
  match ':controller(/:action(/:id(.:format)))'
end
