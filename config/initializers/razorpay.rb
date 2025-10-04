# Razorpay Configuration
# These are test credentials - replace with your production keys for live payments
Razorpay.setup(
  ENV['RAZORPAY_KEY_ID'] || 'rzp_test_RPMGT6LIDBDvjv',
  ENV['RAZORPAY_KEY_SECRET'] || 'JAeTMns5qYXboFgT7leu4CKy'
)

# Log configuration for debugging
Rails.logger.info "Razorpay configured with Key ID: #{ENV['RAZORPAY_KEY_ID'] || 'rzp_test_RPMGT6LIDBDvjv'}"
