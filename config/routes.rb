Rails.application.routes.draw do
  # API
  constraints subdomain: 'api' do
    scope module: "v1" do
      resources :events, only: [:index]
      resources :meetup_groups, only: [:index]
    end
  end

  # Route *. to www.
  match '(*any)', to: redirect { |params, request|
      URI.parse(request.url).tap { |uri| uri.host = "www.#{uri.host}" }.to_s
    }, via: :all, constraints: RootDomainConstraint.new(:api, :www)

  # App
  root to: 'events#index'
  resources :events, except: [:destroy]
  resources :meetup_groups, except: [:edit, :update, :destroy]
  resources :urls, only: [:index, :show]
  resources :archived_urls, only: [:create]
  resources :cleaned_urls, only: [:create]
  resources :tweet_processing_jobs, only: [:create]

  resources :sessions, only: [:new, :create, :destroy]
  get '/in', to: 'sessions#new', as: :in
  delete '/out', to: 'sessions#destroy', as: :out
  get 'auth/:provider/callback' => 'sessions#create'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
