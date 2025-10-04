class CreateSavedCards < ActiveRecord::Migration[8.0]
  def change
    create_table :saved_cards do |t|
      t.references :user, null: false, foreign_key: true
      t.string :razorpay_card_id
      t.string :last4
      t.integer :expiry_month
      t.integer :expiry_year
      t.string :card_type

      t.timestamps
    end
    add_index :saved_cards, :razorpay_card_id, unique: true
  end
end
