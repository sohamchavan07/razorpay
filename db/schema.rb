# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_10_03_180532) do
  create_table "payments", force: :cascade do |t|
    t.string "razorpay_payment_id"
    t.integer "user_id", null: false
    t.integer "amount"
    t.string "currency"
    t.string "status"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["razorpay_payment_id"], name: "index_payments_on_razorpay_payment_id", unique: true
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "refunds", force: :cascade do |t|
    t.string "razorpay_refund_id"
    t.integer "payment_id", null: false
    t.integer "amount"
    t.string "status"
    t.string "reason"
    t.text "notes"
    t.string "idempotency_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idempotency_key"], name: "index_refunds_on_idempotency_key", unique: true
    t.index ["payment_id"], name: "index_refunds_on_payment_id"
    t.index ["razorpay_refund_id"], name: "index_refunds_on_razorpay_refund_id", unique: true
  end

  create_table "saved_cards", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "razorpay_card_id"
    t.string "last4"
    t.integer "expiry_month"
    t.integer "expiry_year"
    t.string "card_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["razorpay_card_id"], name: "index_saved_cards_on_razorpay_card_id", unique: true
    t.index ["user_id"], name: "index_saved_cards_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "razorpay_subscription_id"
    t.string "plan_id"
    t.string "status"
    t.datetime "started_at"
    t.datetime "current_start"
    t.datetime "current_end"
    t.datetime "ended_at"
    t.integer "quantity"
    t.datetime "charge_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["razorpay_subscription_id"], name: "index_subscriptions_on_razorpay_subscription_id", unique: true
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "webhook_events", force: :cascade do |t|
    t.string "razorpay_event_id"
    t.string "event_type"
    t.string "status"
    t.datetime "processed_at"
    t.text "raw_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["razorpay_event_id"], name: "index_webhook_events_on_razorpay_event_id", unique: true
  end

  add_foreign_key "payments", "users"
  add_foreign_key "refunds", "payments"
  add_foreign_key "saved_cards", "users"
  add_foreign_key "subscriptions", "users"
end
