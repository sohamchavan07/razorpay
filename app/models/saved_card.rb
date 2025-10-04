class SavedCard < ApplicationRecord
  belongs_to :user

  validates :razorpay_card_id, presence: true, uniqueness: true
  validates :last4, presence: true, length: { is: 4 }
  validates :expiry_month, presence: true, inclusion: { in: 1..12 }
  validates :expiry_year, presence: true, numericality: { greater_than_or_equal_to: Date.current.year }
  validates :card_type, presence: true

  scope :active, -> { where("expiry_year > ? OR (expiry_year = ? AND expiry_month >= ?)", Date.current.year, Date.current.year, Date.current.month) }

  def expired?
    expiry_year < Date.current.year || (expiry_year == Date.current.year && expiry_month < Date.current.month)
  end

  def formatted_expiry
    "#{expiry_month.to_s.rjust(2, '0')}/#{expiry_year}"
  end

  def masked_number
    "**** **** **** #{last4}"
  end
end
