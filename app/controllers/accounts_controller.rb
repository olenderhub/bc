class AccountsController < ApplicationController

  def index
  end

  def new
    @account = Account.new
    @account.build_person
  end

  def create
    @account = Account.new(account_params)
    respond_to do |format|
      if @account.save
        AccountMailer.welcome_email(@account).deliver_now
        format.html { redirect_to(root_url) }
      else
        format.html { render action: 'new' }
      end
    end
  end

  private

  def account_params
    params.require(:account).permit(:email, :password, :password_confirmation, person_attributes: [:first_name, :last_name])
  end
end
