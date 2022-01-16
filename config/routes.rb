Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users do
        post :add_transaction, to: 'transactions#add_transaction'
        put  :spend, to: 'transactions#spend'
        get  :balance, to: 'transactions#balance'
      end
      resources :payers do
        resources :transactions
      end
    end
  end
end

