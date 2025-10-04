#!/usr/bin/env ruby

# Simple API test script for Razorpay Payment API
# Run with: ruby test_api.rb

require 'net/http'
require 'json'
require 'uri'

BASE_URL = 'http://localhost:3000'

def make_request(method, path, body = nil, headers = {})
  uri = URI("#{BASE_URL}#{path}")
  http = Net::HTTP.new(uri.host, uri.port)
  
  case method.upcase
  when 'GET'
    request = Net::HTTP::Get.new(uri)
  when 'POST'
    request = Net::HTTP::Post.new(uri)
  when 'PATCH'
    request = Net::HTTP::Patch.new(uri)
  when 'DELETE'
    request = Net::HTTP::Delete.new(uri)
  end
  
  headers.each { |key, value| request[key] = value }
  request['Content-Type'] = 'application/json' if body
  request.body = body.to_json if body
  
  response = http.request(request)
  
  puts "#{method} #{path}"
  puts "Status: #{response.code}"
  puts "Response: #{response.body}"
  puts "=" * 50
  
  response
end

def test_health_check
  puts "Testing Health Check..."
  make_request('GET', '/')
end

def test_create_subscription
  puts "Testing Create Subscription..."
  
  subscription_data = {
    subscription: {
      email: "test@example.com",
      name: "Test User",
      plan_id: "plan_test123",
      quantity: 1
    }
  }
  
  make_request('POST', '/api/v1/subscriptions/create', subscription_data)
end

def test_save_card
  puts "Testing Save Card..."
  
  card_data = {
    saved_card: {
      razorpay_card_id: "card_test123"
    }
  }
  
  # First create a user
  user = User.create!(email: "test@example.com", name: "Test User")
  
  make_request('POST', "/api/v1/users/#{user.id}/save-card", card_data)
end

def test_list_cards
  puts "Testing List Cards..."
  
  user = User.find_by(email: "test@example.com")
  if user
    make_request('GET', "/api/v1/users/#{user.id}/cards")
  else
    puts "User not found. Please create a user first."
  end
end

def test_admin_refund
  puts "Testing Admin Refund..."
  
  refund_data = {
    refund: {
      payment_id: "pay_test123",
      amount: 1000,
      reason: "Test refund"
    }
  }
  
  headers = {
    'Authorization' => 'Bearer test_admin_token'
  }
  
  make_request('POST', '/api/v1/admin/refund', refund_data, headers)
end

def test_list_refunds
  puts "Testing List Refunds..."
  
  headers = {
    'Authorization' => 'Bearer test_admin_token'
  }
  
  make_request('GET', '/api/v1/admin/refunds', nil, headers)
end

# Main test execution
if __FILE__ == $0
  puts "Razorpay Payment API Test Script"
  puts "=" * 50
  
  begin
    test_health_check
    test_create_subscription
    test_save_card
    test_list_cards
    test_admin_refund
    test_list_refunds
    
    puts "All tests completed!"
  rescue => e
    puts "Error: #{e.message}"
    puts e.backtrace
  end
end
