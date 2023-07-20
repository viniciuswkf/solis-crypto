class SessionsController < ApplicationController
  before_action :authorize_request, except: :create


  def index
    render json: { id: @current_user.id, name: @current_user.name, balance: @current_user.balance, email: @current_user.email }
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M")
                      }, status: :ok
    else
      render json: { errors:[ 'Invalid credentials'] }, status: :unauthorized
    end
  end

  private

  def sessions_params
    params.permit(:email, :password)
  end
end
