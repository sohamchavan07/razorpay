#!/usr/bin/env ruby
# Test script for Razorpay payment cards
# Run with: ruby test_payment_cards.rb

puts "🧪 Razorpay Test Cards Guide"
puts "=" * 50

puts "\n✅ RECOMMENDED TEST CARDS (Indian - Will Work):"
puts "-" * 40
puts "Visa Credit:     4111 1111 1111 1111"
puts "Mastercard:      5555 5555 5555 4444"
puts "RuPay:           6070 0000 0000 0000"
puts "CVV:             Any 3 digits (e.g., 123)"
puts "Expiry:          Any future date (e.g., 12/25)"

puts "\n❌ AVOID THESE CARDS (International - Will Fail):"
puts "-" * 40
puts "American Express: 3782 8224 6310 005"
puts "Diners Club:      3056 9309 0259 04"
puts "JCB:              3530 1113 3330 0000"

puts "\n🔧 ALTERNATIVE PAYMENT METHODS:"
puts "-" * 40
puts "UPI:              Use any UPI ID (e.g., test@paytm)"
puts "Net Banking:      Select any bank from the list"
puts "Wallets:          Use test wallet credentials"

puts "\n🚀 TESTING STEPS:"
puts "-" * 40
puts "1. Start your Rails server: rails server"
puts "2. Visit: http://localhost:3000/payments/new"
puts "3. Enter amount: ₹199"
puts "4. Use one of the recommended test cards above"
puts "5. If cards fail, try UPI or Net Banking"

puts "\n🔍 TROUBLESHOOTING:"
puts "-" * 40
puts "• If you see 'International cards not supported':"
puts "  → Use Indian test cards only"
puts "  → Try UPI or Net Banking instead"
puts "• If payment fails:"
puts "  → Check browser console for errors"
puts "  → Verify Razorpay credentials"
puts "  → Check server logs"

puts "\n📞 NEED HELP?"
puts "-" * 40
puts "• Razorpay Docs: https://razorpay.com/docs/"
puts "• Test Cards: https://razorpay.com/docs/payment-gateway/test-cards/"
puts "• Support: https://razorpay.com/support/"

puts "\n" + "=" * 50
puts "💡 Pro Tip: Always use Indian test cards to avoid international card errors!"
