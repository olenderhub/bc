require "test_helper"

class AccountsTest < ActionDispatch::IntegrationTest

  test "User registration and verification of sending email" do
    assert_difference 'Account.count', 1 do
      visit '/register'
      fill_in('account_email', :with => "testmail@test.pl")
      fill_in('account_password', :with => "testmail")
      fill_in('account_password_confirmation', :with => "testmail")
      fill_in('account_person_attributes_first_name', :with => "testmailname")
      fill_in('account_person_attributes_last_name', :with => "testmaillastname")
      click_on(I18n.t(:create_new_account, scope: ['activerecord.account']).capitalize)
      visit '/login'
      fill_in(I18n.t(:email, scope: ['activerecord.session']).capitalize, :with => "testmail@test.pl")
      fill_in(I18n.t(:password, scope: ['activerecord.session']).capitalize, :with => "testmail")
      click_on(I18n.t(:Log_in, scope: ['activerecord.session']).capitalize)
    end
  end

  test "user logs in with Facebook" do
    mock_auth
    visit '/parkings'
    click_link 'Log in with Facebook'
    assert has_content? 'first_name last_name'
  end
end


