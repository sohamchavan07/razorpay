class CreateWebhookEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :webhook_events do |t|
      t.string :razorpay_event_id
      t.string :event_type
      t.string :status
      t.datetime :processed_at
      t.text :raw_data

      t.timestamps
    end
    add_index :webhook_events, :razorpay_event_id, unique: true
  end
end
