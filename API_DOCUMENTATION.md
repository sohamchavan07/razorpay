# Razorpay Payment API Documentation

This Rails application provides a comprehensive payment system using Razorpay with support for subscriptions, saved cards, refunds, and webhooks.

## Features Implemented

### 1. Recurring Payments / Subscriptions
- Create subscriptions using Razorpay Plans
- Manage subscription lifecycle (pause, resume, cancel)
- Handle subscription billing and payments
- Support for plan-based recurring billing

### 2. Saved Cards (Tokenization)
- Save card tokens after successful payments
- List user's saved cards
- Delete saved cards
- Secure card information storage

### 3. Refunds
- Admin-protected refund functionality
- Idempotency support to prevent duplicate refunds
- Integration with Razorpay refund API
- Automatic payment status updates

### 4. Webhooks & Asynchronous Events
- Secure webhook signature verification
- Idempotency handling for webhook events
- Background job processing for webhook events
- Support for subscription and payment webhooks

## API Endpoints

### Health Check
```
GET /
```
Returns API status and timestamp.

### Subscriptions

#### Create Subscription
```
POST /api/v1/subscriptions/create
```

**Request Body:**
```json
{
  "subscription": {
    "email": "user@example.com",
    "name": "John Doe",
    "plan_id": "plan_1234567890",
    "quantity": 1,
    "total_count": 12,
    "start_at": 1640995200,
    "expire_by": 1672531200,
    "notes": {
      "custom_field": "value"
    }
  }
}
```

#### Get Subscription
```
GET /api/v1/subscriptions/:id
```

#### Update Subscription
```
PATCH /api/v1/subscriptions/:id
```

**Request Body:**
```json
{
  "action_type": "pause|resume|cancel",
  "cancel_at_cycle_end": true
}
```

#### Cancel Subscription
```
DELETE /api/v1/subscriptions/:id
```

### Saved Cards

#### Save Card
```
POST /api/v1/users/:user_id/save-card
```

**Request Body:**
```json
{
  "saved_card": {
    "razorpay_card_id": "card_1234567890"
  }
}
```

#### List User Cards
```
GET /api/v1/users/:user_id/cards
```

#### Delete Card
```
DELETE /api/v1/saved_cards/:id
```

### Admin Refunds

#### Create Refund
```
POST /api/v1/admin/refund
```

**Headers:**
```
Authorization: Bearer <admin_jwt_token>
```

**Request Body:**
```json
{
  "refund": {
    "payment_id": "pay_1234567890",
    "amount": 1000,
    "reason": "Customer request",
    "notes": "Refund notes",
    "idempotency_key": "unique_key_123"
  }
}
```

#### List Refunds
```
GET /api/v1/admin/refunds?status=pending&payment_id=pay_123
```

### Webhooks

#### Payment Webhooks
```
POST /api/v1/webhooks/payments
```

**Headers:**
```
X-Razorpay-Signature: <webhook_signature>
Content-Type: application/json
```

## Configuration

### Environment Variables
Add these to your Rails credentials:

```yaml
razorpay_key_id: "your_razorpay_key_id"
razorpay_key_secret: "your_razorpay_key_secret"
razorpay_webhook_secret: "your_webhook_secret"
jwt_secret: "your_jwt_secret"
```

### Database Setup
```bash
rails db:migrate
```

### Background Jobs
The application uses Sidekiq for background job processing. Start Sidekiq:

```bash
bundle exec sidekiq
```

## Security Features

### 1. Webhook Signature Verification
- HMAC SHA256 signature verification
- Secure comparison to prevent timing attacks
- Rejection of unsigned or invalid signatures

### 2. Admin Authentication
- JWT-based authentication for admin endpoints
- Token expiration handling
- Role-based access control

### 3. Idempotency
- Idempotency keys for refund operations
- Webhook event deduplication
- Prevents duplicate processing

### 4. Data Validation
- Comprehensive model validations
- Input sanitization
- Error handling and logging

## Webhook Events Handled

- `subscription.charged` - Subscription payment successful
- `subscription.failed` - Subscription payment failed
- `subscription.completed` - Subscription completed
- `subscription.cancelled` - Subscription cancelled
- `payment.captured` - Payment captured
- `payment.failed` - Payment failed
- `refund.processed` - Refund processed
- `refund.failed` - Refund failed

## Error Handling

All endpoints return consistent error responses:

```json
{
  "error": "Error message"
}
```

HTTP status codes:
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Unprocessable Entity
- `500` - Internal Server Error

## Testing

Run the test suite:

```bash
rails test
```

## Production Considerations

1. **Security**: Use strong JWT secrets and webhook secrets
2. **Monitoring**: Set up logging and monitoring for webhook processing
3. **Scaling**: Consider Redis for Sidekiq in production
4. **Backup**: Regular database backups
5. **SSL**: Use HTTPS in production
6. **Rate Limiting**: Implement rate limiting for API endpoints

## Example Usage

### Creating a Subscription
```bash
curl -X POST http://localhost:3000/api/v1/subscriptions/create \
  -H "Content-Type: application/json" \
  -d '{
    "subscription": {
      "email": "user@example.com",
      "name": "John Doe",
      "plan_id": "plan_1234567890",
      "quantity": 1
    }
  }'
```

### Processing a Refund
```bash
curl -X POST http://localhost:3000/api/v1/admin/refund \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <admin_jwt_token>" \
  -d '{
    "refund": {
      "payment_id": "pay_1234567890",
      "amount": 1000,
      "reason": "Customer request"
    }
  }'
```

This implementation provides a robust foundation for handling payments, subscriptions, and refunds with Razorpay integration.
