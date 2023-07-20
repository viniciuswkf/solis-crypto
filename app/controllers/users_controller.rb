class UsersController < ApplicationController
  before_action :authorize_request, except: %i[create]
  before_action :find_user, except: %i[create]


  # POST /users
  def create
    @user = User.new(create_user_params)
    if @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M")
                      }, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /users/{id}
  def update
    unless @user.update(update_user_params)
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end


  private
  def find_user
    @user = User.find!(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ["User not found"] }, status: :not_found
  end

  def update_user_params
    params.permit(
      :name, :password
    )
  end

  def create_user_params
    params.permit(
      :name, :email, :password
    )
  end
end
