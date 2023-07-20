class TransactionsController  < ApplicationController
  before_action :authorize_request

  def index
    deposits = Deposit.where(user_id: @current_user.id)
    deposits_with_type = deposits.map { |deposit| deposit.attributes.merge("type" => "deposit") }
    withdraws = Withdraw.where(user_id: @current_user.id)
    withdraws_with_type = withdraws.map { |withdraw| withdraw.attributes.merge("type" => "withdraw") }

    ## merge deposits + withdraws in transactions list
    transactions = deposits_with_type + withdraws_with_type

    # get by most recent
    recents_sorted_transactions = transactions.sort_by { |item| item["created_at"] }.reverse

    # Remove attributes "pricing" and "addresses" from each item
    recents_sorted_transactions.each do |transaction|
      transaction.delete("pricing")
      transaction.delete("addresses")
    end

    render json: recents_sorted_transactions
  end


end
