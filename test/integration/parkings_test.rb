require 'test_helper'

class ParkingsTest < ActionDispatch::IntegrationTest

  setup do
    log_in
  end

  test "user opens parkings index" do
    visit parkings_path
    assert has_content? 'Parkings'
  end

  test "user opens parkings show" do
    visit parkings_path
    click_link(I18n.t(:show, scope: ['activerecord.parking']).capitalize)
    assert has_content? 'Parkings'
  end

  test "user adds a new parking" do
    visit parkings_path
    click_link(I18n.t(:create_new_parking, scope: ['activerecord.parking']))
    fill_in('parking_places', :with => 2)
    select((I18n.t(:street, scope: ['activerecord.parking'])), :from => 'parking_kind')
    fill_in('parking_day_price', :with => 10)
    fill_in('parking_hour_price', :with => 10)
    fill_in('parking_address_attributes_city', :with => "bigcity")
    fill_in('parking_address_attributes_street', :with => "nicestreet")
    fill_in('parking_address_attributes_zip_code', :with => "10-100")
    click_on(I18n.t(:create_new_parking, scope: ['activerecord.parking']))
    assert has_content? 'Parkings'
    assert has_content? 'bigcity'
  end

  test "user edits a parking" do
    visit parkings_path
    click_link(I18n.t(:edit, scope: ['activerecord.parking']).capitalize)
    fill_in('parking_places', :with => 2)
    select((I18n.t(:street, scope: ['activerecord.parking'])), :from => 'parking_kind')
    fill_in('parking_hour_price', :with => 100)
    fill_in('parking_day_price', :with => 10)
    fill_in('parking_address_attributes_city', :with => "Bigcity")
    fill_in('parking_address_attributes_street', :with => "nicestreet")
    fill_in('parking_address_attributes_zip_code', :with => "10-100")
    click_on(I18n.t(:create_new_parking, scope: ['activerecord.parking']))
    assert has_content? 'Bigcity'
  end

  test "user removes a parking" do
    Capybara.current_driver = Capybara.javascript_driver
    visit parkings_path
    # sleep 10
    click_link(I18n.t(:remove, scope: ['activerecord.parking']).capitalize)
    page.driver.browser.switch_to.alert.accept
    assert has_content? 'Parkings'
    assert has_no_content?('bigcity')
  end

  test "user searchs in form and makes sure the data stay in the form when it's submitted" do
    visit parkings_path
    fill_in(I18n.t(:day_price_from, scope: ['activerecord.parking']).capitalize, :with => 13)
    fill_in(I18n.t(:day_price_to, scope: ['activerecord.parking']).capitalize, :with => 15)
    fill_in(I18n.t(:hour_price_from, scope: ['activerecord.parking']).capitalize, :with => 1)
    fill_in(I18n.t(:hour_price_to, scope: ['activerecord.parking']).capitalize, :with => 2)
    fill_in(I18n.t(:city, scope: ['activerecord.parking']).capitalize, :with => "Warsaw")
    page.check(I18n.t(:private, scope: ['activerecord.parking']).capitalize)
    page.check(I18n.t(:public, scope: ['activerecord.parking']).capitalize)
    click_on(I18n.t(:search, scope: ['activerecord.parking']).capitalize)
    assert_equal "13", find_field("day_price_from").value
    assert_equal "15", find_field("day_price_to").value
    assert_equal "1", find_field("hour_price_from").value
    assert_equal "2", find_field("hour_price_to").value
    assert_equal "Warsaw", find_field("city").value
    assert has_checked_field?("private")
    assert has_checked_field?("public")
  end

  test "user searchs in form and makes sure that it works" do
    visit parkings_path
    fill_in(I18n.t(:day_price_from, scope: ['activerecord.parking']).capitalize, :with => 13)
    fill_in(I18n.t(:day_price_to, scope: ['activerecord.parking']).capitalize, :with => 15)
    fill_in(I18n.t(:hour_price_from, scope: ['activerecord.parking']).capitalize, :with => 1)
    fill_in(I18n.t(:hour_price_to, scope: ['activerecord.parking']).capitalize, :with => 2)
    click_on(I18n.t(:search, scope: ['activerecord.parking']).capitalize)
    assert has_content? '1.0'
    assert has_content? '15.0'
  end
end
