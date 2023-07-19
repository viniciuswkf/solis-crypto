class DepositsController < ApplicationController
  before_action :authorize_request
  before_action :set_deposit, only: %i[ show destroy ]

  # GET /deposits
  def index
    @deposits = Deposit.where({user_id: @current_user.id})

    render json: @deposits
  end

  # GET /deposits/1
  def show
    render json: @deposit
  end

  # POST /deposits
  def create




    if params[:amount] < 10
      render json: {errors: ['Enter amount above 10']}.to_json, status: :unprocessable_entity
    end

    @deposit = Deposit.new(deposit_params)

    if @deposit.save
      render json: @deposit, status: :created, location: @deposit
    else
      render json: @deposit.errors, status: :unprocessable_entity
    end
  end


  # DELETE /deposits/1
  def destroy
    @deposit.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deposit
      @deposit = Deposit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def deposit_params
      params.permit(:amount)
    end
end
