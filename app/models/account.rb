class Account < ActiveRecord::Base
  belongs_to :person

  accepts_nested_attributes_for :person

  has_secure_password

  def self.authenticate(email, password)

  	account = Account.where(email: email).first
  	if account
  	  account.authenticate(password)
    end
  end
end
