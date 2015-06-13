class SessionController < ApplicationController

  def new
  end

  def create
    if auth_hash.present? && auth_hash.has_key?(:uid)
      person = FacebookAccount.find_or_create_for_facebook(auth_hash)
      session[:current_user_id] = person.id
      redirect_to session[:return_to] || root_path
    else
      if account = Account.authenticate(params[:email], params[:password_digest])
        session[:current_user_id] = account.id
        redirect_to session[:return_to] || root_path
      else
        render action: "new"
        flash.now[:alert] = "There is no account with this params"
      end
    end
  end

  def failure
    redirect_to parkings_path
    flash.now[:alert] = "Authentication failed"
  end

  def destroy
  	reset_session
    redirect_to root_path
  end

  def auth_hash
    request.env["omniauth.auth"]
  end
end

