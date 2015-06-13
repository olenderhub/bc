require 'test_helper'

class PlaceRentsTest < ActionDispatch::IntegrationTest

  setup do
    log_in
  end

  test "user rents a place" do
    visit '/'
    click_link(I18n.t(:rent_a_place, scope: ['activerecord.place_rent']).capitalize)
    select '2017', :from => 'place_rent_starts_at_1i'
    select I18n.t(:december, scope: ['activerecord.place_rent']).capitalize, :from => 'place_rent_starts_at_2i'
    select '13', :from => 'place_rent_starts_at_3i'
    select '2018', :from => 'place_rent_ends_at_1i'
    select I18n.t(:december, scope: ['activerecord.place_rent']).capitalize, :from => 'place_rent_ends_at_2i'
    select '13', :from => 'place_rent_ends_at_3i'
    click_on(I18n.t(:rent_a_place, scope: ['activerecord.place_rent']).capitalize)
    assert has_content? '2017-12-13'
    assert has_content? '2018-12-13'
  end

  test "user sees new price of place rent when parking price will change" do
    visit '/parkings'
    click_link(I18n.t(:edit, scope: ['activerecord.parking']).capitalize)
    fill_in('parking_day_price', :with => 9)
    click_on((I18n.t(:create_new_parking, scope: ['activerecord.parking'])))
    visit '/place_rents'
    assert_equal(true, find(".price").has_content?('52.0'))
  end

  test "user sees new ends_at with current time in his place rents when parking will be destroyed and have ends_at > current time" do
    visit '/parkings'
    within("tr.place-rent-#{parkings(:parking1).id}") do
      click_link(I18n.t(:remove, scope: ['activerecord.parking']).capitalize)
    end
    visit '/place_rents'
    assert has_no_content?('2016-02-27')
  end

  test "user checks price of place rent from list of place rents" do
    visit '/place_rents'
    assert has_content? "52.0"
  end
end
