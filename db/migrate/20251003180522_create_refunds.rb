class CreateRefunds < ActiveRecord::Migration[8.0]
  def change
    create_table :refunds do |t|
      t.string :razorpay_refund_id
      t.references :payment, null: false, foreign_key: true
      t.integer :amount
      t.string :status
      t.string :reason
      t.text :notes
      t.string :idempotency_key

      t.timestamps
    end
    add_index :refunds, :razorpay_refund_id, unique: true
    add_index :refunds, :idempotency_key, unique: true
  end
end
