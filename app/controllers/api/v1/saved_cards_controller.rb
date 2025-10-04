class Api::V1::SavedCardsController < Api::V1::BaseController
  before_action :set_user
  before_action :set_saved_card, only: [ :destroy ]

  def create
    begin
      # The card token should be provided by the client after tokenization
      # This endpoint stores the card details after successful tokenization
      razorpay_card = Razorpay::Card.fetch(saved_card_params[:razorpay_card_id])

      saved_card = @user.saved_cards.create!({
        razorpay_card_id: saved_card_params[:razorpay_card_id],
        last4: razorpay_card.last4,
        expiry_month: razorpay_card.expiry_month,
        expiry_year: razorpay_card.expiry_year,
        card_type: razorpay_card.network
      })

      render json: {
        saved_card: saved_card_response(saved_card),
        message: "Card saved successfully"
      }, status: :created

    rescue Razorpay::Error => e
      render json: { error: "Razorpay Error: #{e.message}" }, status: :unprocessable_entity
    end
  end

  def index
    saved_cards = @user.saved_cards.active.includes(:user)

    render json: {
      saved_cards: saved_cards.map { |card| saved_card_response(card) },
      count: saved_cards.count
    }
  end

  def destroy
    begin
      # Delete card from Razorpay
      Razorpay::Card.delete(@saved_card.razorpay_card_id)

      # Delete local record
      @saved_card.destroy!

      render json: { message: "Card deleted successfully" }
    rescue Razorpay::Error => e
      render json: { error: "Razorpay Error: #{e.message}" }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_saved_card
    @saved_card = @user.saved_cards.find(params[:id])
  end

  def saved_card_params
    params.require(:saved_card).permit(:razorpay_card_id)
  end

  def saved_card_response(saved_card)
    {
      id: saved_card.id,
      razorpay_card_id: saved_card.razorpay_card_id,
      last4: saved_card.last4,
      expiry_month: saved_card.expiry_month,
      expiry_year: saved_card.expiry_year,
      card_type: saved_card.card_type,
      formatted_expiry: saved_card.formatted_expiry,
      masked_number: saved_card.masked_number,
      expired: saved_card.expired?,
      created_at: saved_card.created_at,
      updated_at: saved_card.updated_at
    }
  end
end
