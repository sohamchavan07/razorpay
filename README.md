# Razorpay Payment API

A comprehensive Rails API for handling payments, subscriptions, saved cards, refunds, and webhooks using Razorpay.

## Features

✅ **Recurring Payments / Subscriptions**
- Create subscriptions using Razorpay Plans
- Manage subscription lifecycle (pause, resume, cancel)
- Handle subscription billing and payments

✅ **Saved Cards (Tokenization)**
- Save card tokens after successful payments
- List and manage user's saved cards
- Secure card information storage

✅ **Refunds**
- Admin-protected refund functionality
- Idempotency support to prevent duplicate refunds
- Integration with Razorpay refund API

✅ **Webhooks & Asynchronous Events**
- Secure webhook signature verification
- Idempotency handling for webhook events
- Background job processing for webhook events

## Quick Start

1. **Setup the application:**
   ```bash
   ./setup_razorpay_api.sh
   ```

2. **Configure Razorpay credentials:**
   ```bash
   rails credentials:edit
   ```
   Add your Razorpay credentials:
   ```yaml
   razorpay_key_id: your_key_id
   razorpay_key_secret: your_key_secret
   razorpay_webhook_secret: your_webhook_secret
   jwt_secret: your_jwt_secret
   ```

3. **Start the services:**
   ```bash
   # Terminal 1: Rails server
   rails server
   
   # Terminal 2: Background jobs
   bundle exec sidekiq
   ```

4. **Test the API:**
   ```bash
   ruby test_api.rb
   ```

## API Documentation

Complete API documentation is available in [API_DOCUMENTATION.md](API_DOCUMENTATION.md).

### Key Endpoints

- `POST /api/v1/subscriptions/create` - Create subscription
- `POST /api/v1/users/:id/save-card` - Save card token
- `POST /api/v1/admin/refund` - Process refund
- `POST /api/v1/webhooks/payments` - Webhook endpoint

## Security Features

- 🔐 JWT-based admin authentication
- 🔒 Webhook signature verification
- 🛡️ Idempotency protection
- ✅ Input validation and sanitization

## Tech Stack

- **Ruby on Rails 8.0**
- **Razorpay SDK**
- **Sidekiq** (Background jobs)
- **JWT** (Authentication)
- **SQLite** (Database)

## Requirements

- Ruby 3.0+
- Rails 8.0+
- Razorpay account and API keys
- Redis (for Sidekiq)

## Environment Variables

See [config/environment_variables.example](config/environment_variables.example) for required environment variables.

## Testing

```bash
rails test
ruby test_api.rb  # Manual API testing
```

## Production Deployment

1. Use PostgreSQL or MySQL in production
2. Configure Redis for Sidekiq
3. Set up SSL/HTTPS
4. Configure proper logging and monitoring
5. Set up database backups

## Support

For issues and questions, please refer to the API documentation or create an issue in the repository.
