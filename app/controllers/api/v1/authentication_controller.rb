module Api
  module V1
    class AuthenticationController < ApplicationController
      def register
        user = User.new(user_params)
        user.role ||= "user"
        user.balance ||= 1000000

        if user.save
          token = AuthenticationTokenService.encode(user.id)
          render json: { user: user_response(user), token: token }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          token = AuthenticationTokenService.encode(user.id)
          render json: { user: user_response(user), token: token }, status: :ok
        else
          render json: { errors: "Invalid username or password" }, status: :unauthorized
        end
      end

      private

      def user_params
        params.permit(:name, :email, :password, :password_confirmation)
      end

      def user_response(user)
        {
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role
        }
      end
    end
  end
end
