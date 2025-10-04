#!/bin/bash

# Razorpay Payment API Setup Script
echo "Setting up Razorpay Payment API..."

# Install dependencies
echo "Installing dependencies..."
bundle install

# Setup database
echo "Setting up database..."
rails db:create
rails db:migrate

# Create credentials file if it doesn't exist
if [ ! -f config/credentials.yml.enc ]; then
    echo "Creating credentials file..."
    rails credentials:edit
    echo "Please add your Razorpay credentials to the credentials file:"
    echo "  razorpay_key_id: your_key_id"
    echo "  razorpay_key_secret: your_key_secret"
    echo "  razorpay_webhook_secret: your_webhook_secret"
    echo "  jwt_secret: your_jwt_secret"
fi

# Create log directory
mkdir -p log

# Set executable permissions for test script
chmod +x test_api.rb

echo "Setup complete!"
echo ""
echo "Next steps:"
echo "1. Configure your Razorpay credentials in config/credentials.yml.enc"
echo "2. Start the Rails server: rails server"
echo "3. In another terminal, start Sidekiq: bundle exec sidekiq"
echo "4. Test the API endpoints using the provided test script or API documentation"
echo ""
echo "API Documentation: API_DOCUMENTATION.md"
echo "Test Script: test_api.rb"
echo "Environment Variables Example: config/environment_variables.example"
