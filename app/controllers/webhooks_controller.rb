class WebhooksController < ApplicationController
  def handle_coinbase_payments

    timeline = params.dig('event', 'data', 'timeline')

    last_event = timeline&.last

    if last_event
      status = last_event['status']
      context = last_event['context']

      case status
      when 'COMPLETED' || 'CONFIRMED'
        handle_deposit(params.dig('event'))
      when 'UNRESOLVED'
        handle_deposit(params.dig('event'))
      when 'EXPIRED'

      end
    else
      # Handle the case when "timeline" is nil or empty
      puts 'No events in the timeline.'
    end
    head :ok
  end



  private
  def handle_deposit(event)
    external_id = event.dig('data', 'id')
    paid_amount = event.dig('data', 'payments', 0, 'value', 'local', 'amount').to_i * 100

    deposit = Deposit.find_by(external_id: external_id)

    if deposit.nil?
      return
    end

    user = User.find_by(id: deposit.user_id)

    if user.nil?
      return
    end

    user.update({balance: paid_amount})

    if user.save
      puts "DB | Sucesso no depósito de #{paid_amount / 100} BRL para #{user.email}!"
    else
      puts "DB | Falha no depósito de #{paid_amount / 100} BRL para #{user.email}!"
    end
  end


end
