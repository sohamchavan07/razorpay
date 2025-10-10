class SubscriptionPlansController < ApplicationController
  # Simple marketing page listing subscription plans.
  # For now plans are static; later this can be moved to a model or CMS.
  def index
    @plans = [
      {
        id: "basic",
        name: "Basic",
        price: 199,
        currency: "INR",
        interval: "month",
        features: [ "Access to basic features", "Email support", "Single user" ]
      },
      {
        id: "pro",
        name: "Pro",
        price: 499,
        currency: "INR",
        interval: "month",
        features: [ "Everything in Basic", "Priority support", "Multi-user" ]
      },
      {
        id: "enterprise",
        name: "Enterprise",
        price: 2499,
        currency: "INR",
        interval: "month",
        features: [ "Dedicated account manager", "SLA", "Unlimited users" ]
      }
    ]

    # Razorpay key (if needed for client-side flows)
    @razorpay_key_id = Rails.application.credentials.dig(:razorpay, :key_id) || ENV["RAZORPAY_KEY_ID"]
  end
end
