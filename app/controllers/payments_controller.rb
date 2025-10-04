class PaymentsController < ApplicationController
  protect_from_forgery except: [ :create_order, :verify_payment ]

  def new
    # Pass Razorpay key to the view
    @razorpay_key_id = ENV["RAZORPAY_KEY_ID"] || "rzp_test_RPMGT6LIDBDvjv"
  end

  def create_order
    begin
      # Validate required parameters
      unless params[:amount].present? && params[:currency].present?
        return render json: { error: "Amount and currency are required" }, status: :bad_request
      end

      amount = params[:amount].to_i
      currency = params[:currency].upcase
      full_name = params[:full_name]

      # Validate amount (minimum ₹1)
      if amount < 100 # 100 paise = ₹1
        return render json: { error: "Minimum amount is ₹1" }, status: :bad_request
      end

      # Create Razorpay order
      order = Razorpay::Order.create(
        amount: amount,
        currency: currency,
        receipt: "receipt_#{SecureRandom.hex(8)}",
        notes: {
          full_name: full_name,
          created_at: Time.current.iso8601,
          source: "web_app"
        }
      )

      # Save order details to database (optional)
      # You can create a Payment model to track orders

      render json: {
        order_id: order.id,
        amount: amount,
        currency: currency,
        key: ENV["RAZORPAY_KEY_ID"]
      }
    rescue Razorpay::Error => e
      Rails.logger.error "Razorpay Error: #{e.message}"
      error_message = if e.message.include?("international") || e.message.include?("card")
        "International cards are not supported. Please use Indian cards, UPI, or net banking."
      else
        "Failed to create order. Please try again."
      end
      render json: { error: error_message }, status: :internal_server_error
    rescue => e
      Rails.logger.error "Unexpected Error: #{e.message}"
      render json: { error: "An unexpected error occurred" }, status: :internal_server_error
    end
  end

  def verify_payment
    begin
      payment_id = params[:razorpay_payment_id]
      order_id = params[:razorpay_order_id]
      signature = params[:razorpay_signature]

      # Validate required parameters with more detailed checks
      unless payment_id.present?
        return render json: { error: "Missing payment ID" }, status: :bad_request
      end

      unless order_id.present?
        return render json: { error: "Missing order ID" }, status: :bad_request
      end

      unless signature.present?
        return render json: { error: "Missing signature" }, status: :bad_request
      end

      # Verify payment signature
      Razorpay::Utility.verify_payment_signature(
        razorpay_order_id: order_id,
        razorpay_payment_id: payment_id,
        razorpay_signature: signature
      )

      # Fetch payment details from Razorpay
      payment = Razorpay::Payment.fetch(payment_id)

      # Save payment record to database (optional)
      # You can create a Payment model to store successful payments

      Rails.logger.info "Payment verified successfully: #{payment_id}"

      render json: {
        success: true,
        message: "Payment verified successfully!",
        payment_id: payment_id,
        amount: payment.amount,
        currency: payment.currency
      }
    rescue SecurityError => e
      Rails.logger.error "Signature verification failed: #{e.message}"
      render json: {
        success: false,
        error: "Payment verification failed. Invalid signature."
      }, status: :unprocessable_entity
    rescue Razorpay::Error => e
      Rails.logger.error "Razorpay Error: #{e.message}"
      render json: {
        success: false,
        error: "Payment verification failed. Please contact support."
      }, status: :internal_server_error
    rescue => e
      Rails.logger.error "Unexpected Error: #{e.message}"
      render json: {
        success: false,
        error: "An unexpected error occurred during verification."
      }, status: :internal_server_error
    end
  end
end
