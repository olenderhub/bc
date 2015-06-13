class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception

  before_action :set_locale

  helper_method :current_person
  helper_method :current_placerent


  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def login_required
    if session[:current_user_id] == nil
      session[:return_to] = request.original_url
      redirect_to root_path
      flash[:alert] = "You are not logged in"
    end
  end

  private

  def current_person
    current_user_id = session[:current_user_id]

    if current_user_id && Account.exists?(current_user_id)
      @current_person = Account.find(current_user_id).person
    else
      @current_person = FacebookAccount.find(current_user_id).person
    end
    @current_person
  end

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first if request.env['HTTP_ACCEPT_LANGUAGE'] != nil
  end

  def set_locale
    I18n.locale = session[:locale] || params[:locale] || extract_locale_from_accept_language_header
  end
end
