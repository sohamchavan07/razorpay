class Api::V1::Admin::RefundsController < Api::V1::BaseController
  include JwtAuthentication
  before_action :authenticate_admin!
  before_action :set_payment, only: [:create]

  def create
    begin
      # Validate payment eligibility for refund
      unless @payment.captured?
        return render json: { error: "Payment is not captured and cannot be refunded" }, status: :unprocessable_entity
      end

      refund_amount = refund_params[:amount] || @payment.amount
      
      # Check if refund amount is valid
      if refund_amount > @payment.refundable_amount
        return render json: { 
          error: "Refund amount exceeds refundable amount", 
          refundable_amount: @payment.refundable_amount 
        }, status: :unprocessable_entity
      end

      # Check for idempotency
      if refund_params[:idempotency_key].present?
        existing_refund = Refund.find_by(idempotency_key: refund_params[:idempotency_key])
        if existing_refund
          return render json: {
            refund: refund_response(existing_refund),
            message: "Refund already processed with this idempotency key"
          }
        end
      end

      # Create refund on Razorpay
      razorpay_refund = Razorpay::Payment.fetch(@payment.razorpay_payment_id).refund({
        amount: refund_amount,
        notes: {
          reason: refund_params[:reason],
          admin_id: current_admin[:id],
          timestamp: Time.current.iso8601
        }
      })

      # Create local refund record
      refund = @payment.refunds.create!({
        razorpay_refund_id: razorpay_refund.id,
        amount: razorpay_refund.amount,
        status: razorpay_refund.status,
        reason: refund_params[:reason],
        notes: refund_params[:notes],
        idempotency_key: refund_params[:idempotency_key]
      })

      # Update payment status if fully refunded
      if @payment.fully_refunded?
        @payment.update!(status: 'refunded')
      end

      render json: {
        refund: refund_response(refund),
        razorpay_refund: razorpay_refund,
        message: "Refund processed successfully"
      }, status: :created

    rescue Razorpay::Error => e
      render json: { error: "Razorpay Error: #{e.message}" }, status: :unprocessable_entity
    end
  end

  def index
    refunds = Refund.includes(:payment, payment: :user)
                   .order(created_at: :desc)
                   .limit(100)

    # Apply filters if provided
    if params[:status].present?
      refunds = refunds.where(status: params[:status])
    end

    if params[:payment_id].present?
      refunds = refunds.where(payment_id: params[:payment_id])
    end

    render json: {
      refunds: refunds.map { |refund| refund_response(refund) },
      count: refunds.count,
      filters: {
        status: params[:status],
        payment_id: params[:payment_id]
      }
    }
  end

  private


  def set_payment
    @payment = Payment.find_by(razorpay_payment_id: refund_params[:payment_id])
    
    unless @payment
      render json: { error: "Payment not found" }, status: :not_found
    end
  end

  def refund_params
    params.require(:refund).permit(
      :payment_id, :amount, :reason, :notes, :idempotency_key
    )
  end

  def refund_response(refund)
    {
      id: refund.id,
      razorpay_refund_id: refund.razorpay_refund_id,
      payment_id: refund.payment_id,
      payment_razorpay_id: refund.payment.razorpay_payment_id,
      amount: refund.amount,
      status: refund.status,
      reason: refund.reason,
      notes: refund.notes,
      idempotency_key: refund.idempotency_key,
      user_email: refund.payment.user.email,
      created_at: refund.created_at,
      updated_at: refund.updated_at
    }
  end
end
