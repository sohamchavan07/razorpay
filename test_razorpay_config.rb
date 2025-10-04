#!/usr/bin/env ruby
# Test Razorpay configuration
# Run with: ruby test_razorpay_config.rb

require_relative 'config/environment'

puts "🧪 Testing Razorpay Configuration"
puts "=" * 50

begin
  # Test Razorpay setup
  puts "✅ Razorpay gem loaded successfully"

  # Check if we can create a test order
  puts "🔍 Testing order creation..."

  test_order = Razorpay::Order.create(
    amount: 100, # ₹1 in paise
    currency: 'INR',
    receipt: "test_#{Time.now.to_i}"
  )

  puts "✅ Test order created successfully!"
  puts "   Order ID: #{test_order.id}"
  puts "   Amount: #{test_order.amount}"
  puts "   Currency: #{test_order.currency}"
  puts "   Status: #{test_order.status}"

  puts "\n🎉 Razorpay configuration is working correctly!"
  puts "💡 You can now start the Rails server and test payments"

rescue Razorpay::Error => e
  puts "❌ Razorpay Error: #{e.message}"
  puts "💡 Check your Razorpay credentials"
rescue => e
  puts "❌ Unexpected Error: #{e.message}"
  puts "💡 Make sure all dependencies are installed"
end

puts "\n" + "=" * 50
puts "🚀 Next steps:"
puts "1. Run: ./start_server.sh"
puts "2. Visit: http://localhost:3000/payments/new"
puts "3. Test with Razorpay test cards"
