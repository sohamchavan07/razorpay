Rails.application.routes.draw do
  get "webhooks/receive"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  namespace :api do
    namespace :v1 do
      # Subscription routes
      post "subscriptions/create", to: "subscriptions#create"
      get "subscriptions/:id", to: "subscriptions#show"
      patch "subscriptions/:id", to: "subscriptions#update"
      delete "subscriptions/:id", to: "subscriptions#destroy"

      # Saved Cards routes
      post "users/:user_id/save-card", to: "saved_cards#create"
      get "users/:user_id/cards", to: "saved_cards#index"
      delete "saved_cards/:id", to: "saved_cards#destroy"

      # Admin Refund routes
      post "admin/refund", to: "admin/refunds#create"
      get "admin/refunds", to: "admin/refunds#index"

      # Webhook routes (no CSRF protection)
      post "webhooks/payments", to: "webhooks#payments"
      post "razorpay_webhook", to: "webhooks#receive", as: :razorpay_webhook
    end
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "api/v1/health#index"
end
