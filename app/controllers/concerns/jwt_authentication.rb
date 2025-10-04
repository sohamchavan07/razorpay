module JwtAuthentication
  extend ActiveSupport::Concern

  private

  def authenticate_admin!
    token = extract_token_from_header
    
    unless token
      render json: { error: "Missing authentication token" }, status: :unauthorized
      return
    end

    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.jwt_secret, true, { algorithm: 'HS256' })
      payload = decoded_token[0]
      
      # Check if token is expired
      if payload['exp'] < Time.current.to_i
        render json: { error: "Token expired" }, status: :unauthorized
        return
      end

      # Check if user is admin
      unless payload['role'] == 'admin'
        render json: { error: "Insufficient permissions" }, status: :forbidden
        return
      end

      @current_admin = {
        id: payload['admin_id'],
        email: payload['email'],
        role: payload['role']
      }

    rescue JWT::DecodeError => e
      Rails.logger.error "JWT decode error: #{e.message}"
      render json: { error: "Invalid token" }, status: :unauthorized
    rescue StandardError => e
      Rails.logger.error "Authentication error: #{e.message}"
      render json: { error: "Authentication failed" }, status: :unauthorized
    end
  end

  def current_admin
    @current_admin
  end

  def extract_token_from_header
    auth_header = request.headers['Authorization']
    return nil unless auth_header&.start_with?('Bearer ')
    
    auth_header.gsub('Bearer ', '')
  end

  def generate_admin_token(admin_id, email)
    payload = {
      admin_id: admin_id,
      email: email,
      role: 'admin',
      exp: 24.hours.from_now.to_i,
      iat: Time.current.to_i
    }

    JWT.encode(payload, Rails.application.credentials.jwt_secret, 'HS256')
  end
end
