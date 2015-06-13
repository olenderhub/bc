require "test_helper"

class CarsTest < ActionDispatch::IntegrationTest

  setup do
    log_in
  end

  test "user shows car" do
    visit "/cars"
    click_link(I18n.t(:show, scope: ['activerecord.car']).capitalize)
    assert has_content? "Cars"
  end

  test "user edits car" do
    visit "/cars"
    click_link(I18n.t(:edit, scope: ['activerecord.car']).capitalize)
    fill_in("car_model", :with => "model_test")
    fill_in("car_registration_number", :with => "registration_test")
    click_on(I18n.t(:create_new_car, scope: ['activerecord.car']).capitalize)
    assert has_content? "model_test"
  end

  test "user removes car" do
    visit cars_path
    assert has_content?("reg1")
    assert has_content?("model1")
    click_link(I18n.t(:remove, scope: ['activerecord.car']).capitalize)
    assert has_content? "Cars"
    assert has_no_content?("reg1")
    assert has_no_content?("model1")
  end

  test "user creates new car" do
    visit cars_path
    click_link(I18n.t(:create_new_car, scope: ['activerecord.car']).capitalize)
    fill_in("car_registration_number", :with => "registration_test2")
    fill_in("car_model", :with => "model_test2")
    click_on(I18n.t(:create_new_car, scope: ['activerecord.car']).capitalize)
    assert has_content? "Cars"
    assert has_content? "model_test2"
  end


  test "user adds new car with a proper picture" do

    assert_difference('Photo.count') do
      visit '/cars/new'
      assert has_content? 'New car'
      fill_in("car_registration_number", :with => "registration_test2")
      fill_in("car_model", :with => "model_test2")
      attach_file 'car_photo_attributes_image', File.join(Rails.root, 'test/fixtures/testfiles/slr.jpg')
      click_on(I18n.t(:create_new_car, scope: ['activerecord.car']).capitalize)
    end
  end
end
