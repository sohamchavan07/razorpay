class WebhookProcessorJob < ApplicationJob
  queue_as :default

  def perform(webhook_event_id)
    webhook_event = WebhookEvent.find(webhook_event_id)
    webhook_event.mark_as_processing!

    begin
      event_data = webhook_event.parsed_data
      event_type = event_data['event']

      case event_type
      when 'subscription.charged'
        process_subscription_charged(event_data)
      when 'subscription.failed'
        process_subscription_failed(event_data)
      when 'subscription.completed'
        process_subscription_completed(event_data)
      when 'subscription.cancelled'
        process_subscription_cancelled(event_data)
      when 'payment.captured'
        process_payment_captured(event_data)
      when 'payment.failed'
        process_payment_failed(event_data)
      when 'refund.processed'
        process_refund_processed(event_data)
      when 'refund.failed'
        process_refund_failed(event_data)
      else
        Rails.logger.info "Unhandled webhook event type: #{event_type}"
      end

      webhook_event.mark_as_completed!

    rescue StandardError => e
      Rails.logger.error "Webhook processing failed for event #{webhook_event.razorpay_event_id}: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      webhook_event.mark_as_failed!
      raise e
    end
  end

  private

  def process_subscription_charged(event_data)
    subscription_data = event_data['payload']['subscription']['entity']
    payment_data = event_data['payload']['payment']['entity']

    # Find or create subscription
    subscription = Subscription.find_by(razorpay_subscription_id: subscription_data['id'])
    
    if subscription
      # Update subscription status
      subscription.update!(
        status: subscription_data['status'],
        current_start: Time.at(subscription_data['current_start']),
        current_end: Time.at(subscription_data['current_end']),
        charge_at: Time.at(subscription_data['charge_at'])
      )

      # Create payment record
      user = subscription.user
      payment = user.payments.find_or_create_by(razorpay_payment_id: payment_data['id']) do |p|
        p.amount = payment_data['amount']
        p.currency = payment_data['currency']
        p.status = payment_data['status']
        p.description = "Subscription payment for plan #{subscription.plan_id}"
      end

      Rails.logger.info "Subscription charged: #{subscription.razorpay_subscription_id}, Payment: #{payment.razorpay_payment_id}"
    else
      Rails.logger.warn "Subscription not found: #{subscription_data['id']}"
    end
  end

  def process_subscription_failed(event_data)
    subscription_data = event_data['payload']['subscription']['entity']

    subscription = Subscription.find_by(razorpay_subscription_id: subscription_data['id'])
    
    if subscription
      subscription.update!(status: subscription_data['status'])
      Rails.logger.info "Subscription failed: #{subscription.razorpay_subscription_id}"
      
      # Send notification to user about failed subscription
      # NotificationJob.perform_async(subscription.user.id, 'subscription_failed', { subscription_id: subscription.id })
    else
      Rails.logger.warn "Subscription not found: #{subscription_data['id']}"
    end
  end

  def process_subscription_completed(event_data)
    subscription_data = event_data['payload']['subscription']['entity']

    subscription = Subscription.find_by(razorpay_subscription_id: subscription_data['id'])
    
    if subscription
      subscription.update!(
        status: subscription_data['status'],
        ended_at: Time.at(subscription_data['ended_at'])
      )
      Rails.logger.info "Subscription completed: #{subscription.razorpay_subscription_id}"
    else
      Rails.logger.warn "Subscription not found: #{subscription_data['id']}"
    end
  end

  def process_subscription_cancelled(event_data)
    subscription_data = event_data['payload']['subscription']['entity']

    subscription = Subscription.find_by(razorpay_subscription_id: subscription_data['id'])
    
    if subscription
      subscription.update!(
        status: subscription_data['status'],
        ended_at: Time.at(subscription_data['ended_at'])
      )
      Rails.logger.info "Subscription cancelled: #{subscription.razorpay_subscription_id}"
    else
      Rails.logger.warn "Subscription not found: #{subscription_data['id']}"
    end
  end

  def process_payment_captured(event_data)
    payment_data = event_data['payload']['payment']['entity']

    payment = Payment.find_by(razorpay_payment_id: payment_data['id'])
    
    if payment
      payment.update!(status: payment_data['status'])
      Rails.logger.info "Payment captured: #{payment.razorpay_payment_id}"
    else
      Rails.logger.warn "Payment not found: #{payment_data['id']}"
    end
  end

  def process_payment_failed(event_data)
    payment_data = event_data['payload']['payment']['entity']

    payment = Payment.find_by(razorpay_payment_id: payment_data['id'])
    
    if payment
      payment.update!(status: payment_data['status'])
      Rails.logger.info "Payment failed: #{payment.razorpay_payment_id}"
    else
      Rails.logger.warn "Payment not found: #{payment_data['id']}"
    end
  end

  def process_refund_processed(event_data)
    refund_data = event_data['payload']['refund']['entity']

    refund = Refund.find_by(razorpay_refund_id: refund_data['id'])
    
    if refund
      refund.update!(status: refund_data['status'])
      Rails.logger.info "Refund processed: #{refund.razorpay_refund_id}"
    else
      Rails.logger.warn "Refund not found: #{refund_data['id']}"
    end
  end

  def process_refund_failed(event_data)
    refund_data = event_data['payload']['refund']['entity']

    refund = Refund.find_by(razorpay_refund_id: refund_data['id'])
    
    if refund
      refund.update!(status: refund_data['status'])
      Rails.logger.info "Refund failed: #{refund.razorpay_refund_id}"
    else
      Rails.logger.warn "Refund not found: #{refund_data['id']}"
    end
  end
end
