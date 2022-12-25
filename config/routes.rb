Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "thaali_takhmeens#index"

  get "/transactions/all", to: "transactions#index", as: :all_transactions
  get "/sabeels", to: "sabeels#index", as: :all_sabeels

  resource :sabeel do
    resource :takhmeen, controller: "thaali_takhmeens" do
      resource :transaction, except: [:new, :edit]
    end
  end

  get "/sabeel/takhmeen/transaction/new", to: "transactions#new", as: :new_takhmeen_transaction
  get "/sabeel/takhmeen/transaction/edit", to: "transactions#edit", as: :edit_takhmeen_transaction
end