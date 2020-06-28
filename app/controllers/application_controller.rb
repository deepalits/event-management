class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
  end

  rescue_from CanCan::AccessDenied, with: :deny_access

  def render_error(data: nil, message: nil, status: :internal_server_error, errors: [])
    render json: { data: data, message: message, errors: errors }, status: status
  end

  private

  def deny_access
    render_error(message: 'You are not authorized to access', status: :forbidden)
  end
end
