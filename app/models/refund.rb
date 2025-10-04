class Refund < ApplicationRecord
  belongs_to :payment

  validates :razorpay_refund_id, presence: true, uniqueness: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending processed failed] }
  validates :reason, presence: true
  validates :idempotency_key, uniqueness: true, allow_nil: true

  scope :processed, -> { where(status: 'processed') }
  scope :failed, -> { where(status: 'failed') }
  scope :pending, -> { where(status: 'pending') }

  def processed?
    status == 'processed'
  end

  def failed?
    status == 'failed'
  end

  def pending?
    status == 'pending'
  end
end
