class Api::V1::HealthController < Api::V1::BaseController
  def index
    render json: { 
      status: "ok", 
      message: "Razorpay Payment API is running",
      timestamp: Time.current.iso8601
    }
  end
end
