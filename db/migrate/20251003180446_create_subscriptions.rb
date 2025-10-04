class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :razorpay_subscription_id
      t.string :plan_id
      t.string :status
      t.datetime :started_at
      t.datetime :current_start
      t.datetime :current_end
      t.datetime :ended_at
      t.integer :quantity
      t.datetime :charge_at

      t.timestamps
    end
    add_index :subscriptions, :razorpay_subscription_id, unique: true
  end
end
