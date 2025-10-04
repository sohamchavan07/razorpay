class User < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  has_many :saved_cards, dependent: :destroy
  has_many :payments, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
end
