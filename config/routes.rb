Rails.application.routes.draw do
  resources :players, only: [:show] do
    collection do
      post 'import', to: 'players#import'
    end
  end
end
