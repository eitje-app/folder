Rails.application.routes.draw do

  namespace :api do

    resources :environments
    resources :billing_infos

    namespace :admin do

      resources :environments
      resources :billing_infos
      
    end

  end

end
