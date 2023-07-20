# app/services/payment_service.rb
require 'httparty'

class CoinbaseService
  include HTTParty
  base_uri 'https://api.commerce.coinbase.com' # Replace this with the actual API endpoint

  def initialize(api_key)
    @api_key = api_key
  end

  def create_deposit(amount, user)
    # Your implementation for making the payment request goes here

    options = {
      body: {
        name: "DEPÓSITO | #{user.name}",
        description: "EMAIL: #{user.email} | ID: #{user.id}",
        local_price: {
          amount: amount / 100,
          currency: 'BRL',
        },
        pricing_type: 'fixed_price',
        metadata: {
        }
      }.to_json,
      headers: {
        'Content-Type' => 'application/json',
        'X-CC-Api-Key' => "#{@api_key}",
        'X-CC-Version' => '2018-03-22'
      }
    }

    response = self.class.post('/charges', options)

    if response.success?
      return response.parsed_response
    else
      return null
    end
  end
end


