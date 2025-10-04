require 'razorpay'

Razorpay.setup(
  Rails.application.credentials.razorpay_key_id,
  Rails.application.credentials.razorpay_key_secret
)

# Configure webhook secret for signature verification
Rails.application.config.razorpay_webhook_secret = Rails.application.credentials.razorpay_webhook_secret
