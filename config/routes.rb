Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: :index do
        post :add_transaction, to: 'transactions#add_transaction'
        put  :spend, to: 'transactions#spend'
        get  :balance, to: 'transactions#balance'
      end
      resources :payers, only: :index
    end
  end
end

