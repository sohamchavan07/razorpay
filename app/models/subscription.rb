class Subscription < ApplicationRecord
  belongs_to :user

  validates :razorpay_subscription_id, presence: true, uniqueness: true
  validates :plan_id, presence: true
  validates :status, presence: true, inclusion: { in: %w[created authenticated active paused halted cancelled completed] }
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  scope :active, -> { where(status: 'active') }
  scope :paused, -> { where(status: 'paused') }
  scope :cancelled, -> { where(status: 'cancelled') }

  def active?
    status == 'active'
  end

  def paused?
    status == 'paused'
  end

  def cancelled?
    status == 'cancelled'
  end
end
