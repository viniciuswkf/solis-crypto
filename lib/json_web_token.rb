class JsonWebToken
  SECRET_KEY = ENV["JWT_SECRET_KEY"]

  def self.encode(payload, exp = 24.hours.from_now)
    p SECRET_KEY
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
