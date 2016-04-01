class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_identity

  PROTECTED_MESSAGE = "You must be signed in to access this page."

  private

  def verify_signed_in
    redirect_to(root_url, notice: PROTECTED_MESSAGE) unless current_identity
  end

  def current_identity
    @current_identity ||= find_identity if session[:identity_id]
  end

  def find_identity
    Identity.find(session[:identity_id])
  rescue ActiveRecord::RecordNotFound => e
    session.delete(:identity_id)
    nil
  end
end
