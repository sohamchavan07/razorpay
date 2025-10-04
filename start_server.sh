#!/bin/bash

# Start Rails server with Razorpay environment variables
echo "🚀 Starting Rails server with Razorpay configuration..."

# Set Razorpay environment variables
export RAZORPAY_KEY_ID=rzp_test_RPMGT6LIDBDvjv
export RAZORPAY_KEY_SECRET=JAeTMns5qYXboFgT7leu4CKy

# Set other required environment variables
export RAILS_ENV=development
export SECRET_KEY_BASE=your_secret_key_base_here_development

echo "✅ Environment variables set:"
echo "   RAZORPAY_KEY_ID: $RAZORPAY_KEY_ID"
echo "   RAZORPAY_KEY_SECRET: [HIDDEN]"
echo "   RAILS_ENV: $RAILS_ENV"
echo ""

# Start the Rails server
echo "🌐 Starting Rails server on http://localhost:3000"
echo "📱 Payment form will be available at: http://localhost:3000/payments/new"
echo ""
echo "💡 Test with Razorpay test cards:"
echo "   Success: 4111 1111 1111 1111"
echo "   Failure: 4000 0000 0000 0002"
echo "   CVV: Any 3 digits"
echo "   Expiry: Any future date"
echo ""

rails server
