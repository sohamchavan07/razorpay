# Razorpay Test Cards Reference

## ✅ Working Test Cards (Indian)

### Credit Cards
- **Visa**: `4111 1111 1111 1111`
- **Mastercard**: `5555 5555 5555 4444`
- **RuPay**: `6070 0000 0000 0000`

### Debit Cards
- **Visa Debit**: `4111 1111 1111 1111`
- **Mastercard Debit**: `5555 5555 5555 4444`

### Test Details for All Cards
- **CVV**: Any 3 digits (e.g., `123`)
- **Expiry**: Any future date (e.g., `12/25`)
- **Name**: Any name (e.g., `Test User`)

## ❌ Cards That May Cause "International Cards Not Supported" Error

### International Cards (Avoid These)
- **American Express**: `3782 8224 6310 005`
- **Diners Club**: `3056 9309 0259 04`
- **JCB**: `3530 1113 3330 0000`

## 🔧 Solutions for International Card Issues

### 1. Use Indian Test Cards Only
Stick to the working test cards listed above.

### 2. Configure Razorpay Account
1. Log into your Razorpay Dashboard
2. Go to Settings → Payment Methods
3. Enable "International Cards" if needed
4. Contact Razorpay support for international card activation

### 3. Alternative Payment Methods
If cards don't work, try:
- **UPI**: Use any UPI ID (e.g., `test@paytm`)
- **Net Banking**: Select any bank from the list
- **Wallets**: Use test wallet credentials

## 🧪 Testing Different Scenarios

### Successful Payment
- Use: `4111 1111 1111 1111`
- CVV: `123`
- Expiry: `12/25`

### Failed Payment
- Use: `4000 0000 0000 0002`
- This will show payment failure

### Insufficient Funds
- Use: `4000 0000 0000 9995`
- This will show insufficient funds error

## 📱 UPI Testing

### Test UPI IDs
- `success@upi`
- `failure@upi`
- `insufficient@upi`

## 🏦 Net Banking Testing

### Test Credentials
- **Bank**: Any bank from the list
- **User ID**: `testuser`
- **Password**: `testpass`

## 🔍 Debugging Tips

1. **Check Browser Console**: Look for JavaScript errors
2. **Network Tab**: Monitor API calls to Razorpay
3. **Razorpay Dashboard**: Check order and payment status
4. **Server Logs**: Check Rails logs for errors

## 🚨 Common Issues & Solutions

### Issue: "International cards are not supported"
**Solution**: 
- Use Indian test cards only
- Check Razorpay account settings
- Contact Razorpay support

### Issue: "Payment failed"
**Solution**:
- Use different test card
- Check amount (minimum ₹1)
- Verify Razorpay credentials

### Issue: "Order creation failed"
**Solution**:
- Check server logs
- Verify Razorpay API keys
- Ensure server is running

## 📞 Support

- **Razorpay Support**: https://razorpay.com/support/
- **Documentation**: https://razorpay.com/docs/
- **Test Mode Guide**: https://razorpay.com/docs/payment-gateway/test-cards/
