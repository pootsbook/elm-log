class SessionsController < ApplicationController
  def new
    redirect_to '/auth/github'
  end

  def create
    identity = Identity.find_or_create_from_omniauth(auth_hash)
    session[:identity_id] = identity.id
    notice = "Signed in!"
  rescue ActiveRecord::RecordNotSaved => e
    notice = "There was a problem signing in."
  ensure
    redirect_to root_url, notice: notice
  end

  def destroy
    session[:identity_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
