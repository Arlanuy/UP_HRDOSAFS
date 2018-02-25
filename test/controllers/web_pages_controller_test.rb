require 'test_helper'

class WebPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get landingpage" do
    get web_pages_landingpage_url
    assert_response :success
  end

  test "should get rsocalculator" do
    get web_pages_rsocalculator_url
    assert_response :success
  end

end
