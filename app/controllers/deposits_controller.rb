class DepositsController < ApplicationController
  before_action :authorize_request
  before_action :set_deposit, except: %i[ create index ]

  # GET /deposits
  def index
    @deposits = Deposit.where({user_id: @current_user.id })

    render json: @deposits
  end

  # GET /deposits/1
  def show
    render json: @deposit
  end

  # POST /deposits
  def create

    amount = params[:amount]

    if amount.nil? || amount.to_i < 1000 #10.00 BRL
      render json: { errors: ["Amount is missing or smaller than 10 BRL"] }, status: :unprocessable_entity
      return
    end

    # Create coinbase order

    coinbase_service = CoinbaseService.new(ENV["COINBASE_API_KEY"])
    result = coinbase_service.create_deposit(amount, @current_user)

    if result.nil?
      render json: { errors: ["Internal server error creating deposit"] }, status: :unprocessable_entity
      return
    end

    addresses = result["data"]["addresses"]
    pricing = result["data"]["pricing"]

    @deposit = Deposit.new({amount: amount, pricing: pricing, addresses: addresses, user_id: @current_user.id, status: "pending"})

    if @deposit.save
      render json: @deposit, status: :created, location: @deposit
    else
      render json: @deposit.errors, status: :unprocessable_entity
    end
  end


  # DELETE /deposits/1
  def destroy
      @deposit.destroy
      render status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deposit
      begin
        @deposit = Deposit.find(params[:id])

        if @deposit.user_id != @current_user.id
          render json: { errors: ["Unauthorized"] }, status: :unauthorized
        end

      rescue
        render json: {errors: ["Deposit not found"]}, status: :not_found
      end

    end

    # Only allow a list of trusted parameters through.
    def create_deposit_params
      params.require(:deposit).(:amount)
    end
end
