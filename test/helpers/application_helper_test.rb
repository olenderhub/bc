require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "Test title" do
  	params[:controller] = 'parkings'
    assert_equal "Parkings", title_of_site
  end
end
