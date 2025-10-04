class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.string :razorpay_payment_id
      t.references :user, null: false, foreign_key: true
      t.integer :amount
      t.string :currency
      t.string :status
      t.text :description

      t.timestamps
    end
    add_index :payments, :razorpay_payment_id, unique: true
  end
end
