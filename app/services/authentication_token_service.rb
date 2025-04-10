class AuthenticationTokenService
  HMAC_SECRET = "my$ecretK3y"
  ALGORITHM_TYPE = "HS256"

  def self.encode(user_id)
    payload = {
      user_id: user_id,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, HMAC_SECRET, ALGORITHM_TYPE)
  end

  def self.decode(token)
    decoded_token = JWT.decode(token, HMAC_SECRET, true, { algorithm: ALGORITHM_TYPE })
    decoded_token[0]["user_id"]
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end
end
