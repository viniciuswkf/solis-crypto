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
    if @deposit.user_id == @current_user.id
      render json: @deposit
    else
      render json: { errors: ["Unauthorized"] }, status: :unauthorized
    end
  end

  # POST /deposits
  def create

    @deposit = Deposit.new({amount: params[:amount], user_id: @current_user.id, status: "pending"})

    if @deposit.save
      render json: @deposit, status: :created, location: @deposit
    else
      render json: @deposit.errors, status: :unprocessable_entity
    end
  end


  # DELETE /deposits/1
  def destroy

    if @deposit.user_id == @current_user.id
      @deposit.destroy
      render status: :ok
    else
      render json: { errors: ["Unauthorized"] }, status: :unauthorized
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deposit
      begin
        @deposit = Deposit.find(params[:id])
      rescue
        render json: {errors: ["Deposit not found"]}, status: :not_found
      end

    end

    # Only allow a list of trusted parameters through.
    def create_deposit_params
      params.require(:deposit).(:amount)
    end
end
