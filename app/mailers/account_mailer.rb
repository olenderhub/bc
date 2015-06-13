class AccountMailer < ApplicationMailer
  default from: "hello@bookparking.dev"

  def welcome_email(account)
    @account = account
    @url  = 'http://bootcamp6-olenderhub.herokuapp.com/login'
    mail(to: @account.email, subject: 'Welcome to Bookparking')
  end
end
