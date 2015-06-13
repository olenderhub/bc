# Preview all emails at http://localhost:3000/rails/mailers/account_mailer
class AccountMailerPreview < ActionMailer::Preview
  def welcome_email
  	account = Account.last
    AccountMailer.welcome_email(account)
  end
end
