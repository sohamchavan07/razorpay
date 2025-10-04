# app/controllers/webhooks_controller.rb
class WebhooksController < ApplicationController
  # Skip CSRF token verification for this specific endpoint
  skip_before_action :verify_authenticity_token

  def receive
    # 1. Get the payload and signature
    payload = request.body.read
    signature = request.headers["X-Razorpay-Signature"]

    # 2. Get your Webhook Secret (from Razorpay Dashboard Webhook Setup)
    webhook_secret = Rails.application.credentials.dig(:razorpay, :webhook_secret)

    begin
      # 3. Verify the signature
      Razorpay::Utility.verify_webhook_signature(payload, signature, webhook_secret)

      # 4. Parse the payload
      event = JSON.parse(payload)

      # 5. Process the event based on its type
      case event["event"]
      when "payment.captured"
        # Logic to fulfill the order, send emails, etc.
        # Access payment data via event['payload']['payment']['entity']
        Rails.logger.info "Razorpay: Payment Captured for ID: #{event['payload']['payment']['entity']['id']}"
      when "payment.failed"
        # Logic to update database status to failed, notify customer, etc.
        Rails.logger.warn "Razorpay: Payment Failed for ID: #{event['payload']['payment']['entity']['id']}"
        # Add more cases for other events you selected (e.g., 'refund.processed')
      end

      # 6. IMPORTANT: Always return a 200 OK status to acknowledge receipt
      head :ok

    rescue Razorpay::Error => e
      # Handle invalid signature or other errors
      Rails.logger.error "Razorpay Webhook Error: Invalid signature or processing failed. #{e.message}"
      # Return a 400 status for security or processing errors
      render json: { error: "Invalid webhook signature or processing error" }, status: :bad_request
    end
  end
end
