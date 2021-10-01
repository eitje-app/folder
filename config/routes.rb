Rails.application.routes.draw do

  namespace :api do

    resources :billing_infos

    namespace :admin do

      resources :billing_infos
      
    end

  end

end
