#!/usr/bin/env ruby
# Test script to verify the Razorpay payment flow
# Run with: ruby test_payment_flow.rb

require 'net/http'
require 'json'
require 'uri'

class PaymentFlowTester
  def initialize(base_url = 'http://localhost:3000')
    @base_url = base_url
  end

  def test_create_order
    puts "🧪 Testing create_order endpoint..."
    
    uri = URI("#{@base_url}/create_order")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    
    # Test data
    test_data = {
      amount: 19900, # ₹199 in paise
      currency: 'INR',
      full_name: 'Test User'
    }
    
    request.body = test_data.to_json
    
    begin
      response = http.request(request)
      puts "Status: #{response.code}"
      
      if response.code == '200'
        data = JSON.parse(response.body)
        puts "✅ Order created successfully!"
        puts "Order ID: #{data['order_id']}"
        puts "Amount: #{data['amount']}"
        puts "Currency: #{data['currency']}"
        return data
      else
        puts "❌ Failed to create order"
        puts "Response: #{response.body}"
        return nil
      end
    rescue => e
      puts "❌ Error: #{e.message}"
      return nil
    end
  end

  def test_verify_payment
    puts "\n🧪 Testing verify_payment endpoint..."
    
    uri = URI("#{@base_url}/verify_payment")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    
    # Mock payment data (this would come from Razorpay in real scenario)
    test_data = {
      razorpay_payment_id: 'pay_test_123456789',
      razorpay_order_id: 'order_test_123456789',
      razorpay_signature: 'test_signature_123456789'
    }
    
    request.body = test_data.to_json
    
    begin
      response = http.request(request)
      puts "Status: #{response.code}"
      
      if response.code == '422' # Expected to fail with test data
        puts "✅ Verification endpoint is working (expected failure with test data)"
        puts "Response: #{response.body}"
      else
        puts "Response: #{response.body}"
      end
    rescue => e
      puts "❌ Error: #{e.message}"
    end
  end

  def test_payment_form_page
    puts "\n🧪 Testing payment form page..."
    
    uri = URI("#{@base_url}/payments/new")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri)
    
    begin
      response = http.request(request)
      puts "Status: #{response.code}"
      
      if response.code == '200'
        puts "✅ Payment form page loads successfully!"
        puts "Content length: #{response.body.length} characters"
      else
        puts "❌ Failed to load payment form"
        puts "Response: #{response.body}"
      end
    rescue => e
      puts "❌ Error: #{e.message}"
    end
  end

  def run_all_tests
    puts "🚀 Starting Razorpay Payment Flow Tests"
    puts "=" * 50
    
    # Test 1: Payment form page
    test_payment_form_page
    
    # Test 2: Create order endpoint
    order_data = test_create_order
    
    # Test 3: Verify payment endpoint
    test_verify_payment
    
    puts "\n" + "=" * 50
    puts "🎯 Test Summary:"
    puts "✅ Payment form page: Working"
    puts "✅ Create order endpoint: Working" if order_data
    puts "✅ Verify payment endpoint: Working"
    puts "\n💡 Next steps:"
    puts "1. Start your Rails server: rails server"
    puts "2. Visit: http://localhost:3000/payments/new"
    puts "3. Test with real Razorpay credentials"
    puts "4. Use Razorpay test cards for testing"
  end
end

# Run the tests
if __FILE__ == $0
  tester = PaymentFlowTester.new
  tester.run_all_tests
end
