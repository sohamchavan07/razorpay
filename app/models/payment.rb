class Payment < ApplicationRecord
  belongs_to :user
  has_many :refunds, dependent: :destroy

  validates :razorpay_payment_id, presence: true, uniqueness: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :status, presence: true, inclusion: { in: %w[created authorized captured refunded failed] }

  scope :captured, -> { where(status: "captured") }
  scope :refunded, -> { where(status: "refunded") }
  scope :failed, -> { where(status: "failed") }

  def captured?
    status == "captured"
  end

  def refunded?
    status == "refunded"
  end

  def failed?
    status == "failed"
  end

  def total_refunded_amount
    refunds.sum(:amount)
  end

  def refundable_amount
    captured? ? (amount - total_refunded_amount) : 0
  end

  def fully_refunded?
    captured? && refundable_amount == 0
  end
end
