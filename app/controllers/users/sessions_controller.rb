# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    respond_to :json

    def user_by_token
      user = user_from_token
      render json: {
        user: user
      }
    end

    private

    def user_from_token
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1],
                               Rails.application.credentials.devise[:jwt_secret_key]).first
      user_id = jwt_payload['sub']
      User.find(user_id.to_s)
    end

    def respond_with(_resource, _opts = {})
      if current_user
        render json: {
          message: 'You are logged in.',
          user: current_user
        }, status: :ok
      else
        render json: { message: 'Please log in' }, status: :unauthorized
      end
    end

    def respond_to_on_destroy
      log_out_success && return if current_user

      log_out_failure
    end

    def log_out_success
      render json: { message: 'You are logged out.' }, status: :ok
    end

    def log_out_failure
      render json: { message: 'Hmm nothing happened.' }, status: :unauthorized
    end
  end
end
