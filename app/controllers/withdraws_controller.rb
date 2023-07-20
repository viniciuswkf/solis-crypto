class WithdrawsController < ApplicationController
  before_action :authorize_request
  before_action :set_withdraw, only: %i[ show update destroy ]

  # GET /withdraws
  def index
    @withdraws = Withdraw.where({user_id: @current_user.id})

    render json: @withdraws
  end

  # GET /withdraws/1
  def show
    render json: @withdraw
  end

  # POST /withdraws
  def create


    amount = params[:amount]
    payment_method = params[:payment_method]
    payment_method_target = params[:payment_method_target]

    if amount.nil? || amount.to_i < 1000 #10.00 BRL
      render json: { errors: ["Amount is missing or smaller than 10 BRL"] }, status: :unprocessable_entity
      return
    end

    allowed_payment_methods = ["PIX"]

    unless allowed_payment_methods.include?(payment_method)
      render json: { errors: ["Invalid payment method"] }, status: :unprocessable_entity
      return
    end


    if payment_method_target.nil? || payment_method_target.empty?
      render json: { errors: ["Payment method target is missing"] }, status: :unprocessable_entity
      return
    end

    if amount > @current_user.balance
      render json: { errors: ["Insufficient funds"] }, status: :unprocessable_entity
      return
    end

    @withdraw = Withdraw.new(user_id: @current_user.id, amount: amount, payment_method: payment_method, payment_method_target: payment_method_target)

    if @withdraw.save
      render json: @withdraw, status: :created, location: @withdraw
    else
      render json: @withdraw.errors, status: :unprocessable_entity
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_withdraw
      begin
        @withdraw = Withdraw.find(params[:id])

        if @withdraw.user_id != @current_user.id
          render json: { errors: ["Unauthorized"] }, status: :unauthorized
        end

      rescue
        render json: {errors: ["Withdraw not found"]}, status: :not_found
      end
    end

    # Only allow a list of trusted parameters through.
    def withdraw_params
      params.permit(:amount, :payment_method, :payment_method_target)
    end
end
