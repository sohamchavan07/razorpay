class Api::V1::SubscriptionsController < Api::V1::BaseController
  before_action :set_subscription, only: [:show, :update, :destroy]

  def create
    begin
      # Find or create user
      user = User.find_or_create_by(email: subscription_params[:email]) do |u|
        u.name = subscription_params[:name]
      end

      # Create subscription on Razorpay
      razorpay_subscription = Razorpay::Subscription.create({
        plan_id: subscription_params[:plan_id],
        customer_id: user.id.to_s,
        quantity: subscription_params[:quantity] || 1,
        total_count: subscription_params[:total_count], # nil for unlimited
        start_at: subscription_params[:start_at] || Time.current.to_i,
        expire_by: subscription_params[:expire_by],
        addons: subscription_params[:addons] || [],
        notes: subscription_params[:notes] || {}
      })

      # Create local subscription record
      subscription = user.subscriptions.create!({
        razorpay_subscription_id: razorpay_subscription.id,
        plan_id: subscription_params[:plan_id],
        status: razorpay_subscription.status,
        started_at: Time.at(razorpay_subscription.started_at),
        current_start: Time.at(razorpay_subscription.current_start),
        current_end: Time.at(razorpay_subscription.current_end),
        ended_at: razorpay_subscription.ended_at ? Time.at(razorpay_subscription.ended_at) : nil,
        quantity: subscription_params[:quantity] || 1,
        charge_at: razorpay_subscription.charge_at ? Time.at(razorpay_subscription.charge_at) : nil
      })

      render json: {
        subscription: subscription_response(subscription),
        razorpay_subscription: razorpay_subscription
      }, status: :created

    rescue Razorpay::Error => e
      render json: { error: "Razorpay Error: #{e.message}" }, status: :unprocessable_entity
    end
  end

  def show
    begin
      # Fetch latest data from Razorpay
      razorpay_subscription = Razorpay::Subscription.fetch(@subscription.razorpay_subscription_id)
      
      # Update local record with latest data
      @subscription.update!({
        status: razorpay_subscription.status,
        current_start: Time.at(razorpay_subscription.current_start),
        current_end: Time.at(razorpay_subscription.current_end),
        ended_at: razorpay_subscription.ended_at ? Time.at(razorpay_subscription.ended_at) : nil,
        charge_at: razorpay_subscription.charge_at ? Time.at(razorpay_subscription.charge_at) : nil
      })

      render json: {
        subscription: subscription_response(@subscription),
        razorpay_subscription: razorpay_subscription
      }
    rescue Razorpay::Error => e
      render json: { error: "Razorpay Error: #{e.message}" }, status: :unprocessable_entity
    end
  end

  def update
    begin
      # Update subscription on Razorpay based on action
      case params[:action_type]
      when 'pause'
        razorpay_subscription = Razorpay::Subscription.pause(@subscription.razorpay_subscription_id)
      when 'resume'
        razorpay_subscription = Razorpay::Subscription.resume(@subscription.razorpay_subscription_id)
      when 'cancel'
        razorpay_subscription = Razorpay::Subscription.cancel(@subscription.razorpay_subscription_id, {
          cancel_at_cycle_end: params[:cancel_at_cycle_end] || false
        })
      else
        return render json: { error: "Invalid action_type. Must be one of: pause, resume, cancel" }, status: :bad_request
      end

      # Update local record
      @subscription.update!({
        status: razorpay_subscription.status,
        ended_at: razorpay_subscription.ended_at ? Time.at(razorpay_subscription.ended_at) : nil
      })

      render json: {
        subscription: subscription_response(@subscription),
        razorpay_subscription: razorpay_subscription
      }
    rescue Razorpay::Error => e
      render json: { error: "Razorpay Error: #{e.message}" }, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      # Cancel subscription on Razorpay
      razorpay_subscription = Razorpay::Subscription.cancel(@subscription.razorpay_subscription_id, {
        cancel_at_cycle_end: true
      })

      # Update local record
      @subscription.update!({
        status: razorpay_subscription.status,
        ended_at: razorpay_subscription.ended_at ? Time.at(razorpay_subscription.ended_at) : nil
      })

      render json: { message: "Subscription cancelled successfully" }
    rescue Razorpay::Error => e
      render json: { error: "Razorpay Error: #{e.message}" }, status: :unprocessable_entity
    end
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(
      :email, :name, :plan_id, :quantity, :total_count, 
      :start_at, :expire_by, :addons, :notes
    )
  end

  def subscription_response(subscription)
    {
      id: subscription.id,
      razorpay_subscription_id: subscription.razorpay_subscription_id,
      plan_id: subscription.plan_id,
      status: subscription.status,
      user_id: subscription.user_id,
      user_email: subscription.user.email,
      quantity: subscription.quantity,
      started_at: subscription.started_at,
      current_start: subscription.current_start,
      current_end: subscription.current_end,
      ended_at: subscription.ended_at,
      charge_at: subscription.charge_at,
      created_at: subscription.created_at,
      updated_at: subscription.updated_at
    }
  end
end
