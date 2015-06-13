require 'test_helper'

class SessionTest < ActionDispatch::IntegrationTest

  test "user sees the person name at the top" do
    log_in
    assert has_content? "MyString1"
  end

  test "user can't see the person name before he log in" do
    visit root_path
    assert has_no_content? "MyString1"
  end

  test "user can log off" do
    log_in
    visit root_path
    click_on(I18n.t(:log_off, scope: ['activerecord.layouts']).capitalize)
    assert has_no_content? "MyString1"
   end

  test "user is redirected after user logged in" do
    visit cars_path
    click_link(I18n.t(:log_in, scope: ['activerecord.session']).capitalize)
    fill_in(I18n.t(:email, scope: ['activerecord.session']).capitalize, :with => "test1@test.pl")
    fill_in(I18n.t(:password, scope: ['activerecord.session']).capitalize, :with => "test1")
    click_on(I18n.t(:Log_in, scope: ['activerecord.session']).capitalize)
    assert_equal cars_path, current_path
   end
end
