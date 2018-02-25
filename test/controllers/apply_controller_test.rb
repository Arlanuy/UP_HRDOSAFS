require 'test_helper'

class ApplyControllerTest < ActionDispatch::IntegrationTest
  test "should get studyleave" do
    get apply_studyleave_url
    assert_response :success
  end

  test "should get dsf" do
    get apply_dsf_url
    assert_response :success
  end

  test "should get sabbatical" do
    get apply_sabbatical_url
    assert_response :success
  end

  test "should get specialdetail" do
    get apply_specialdetail_url
    assert_response :success
  end

  test "should get enrollmentprivileges" do
    get apply_enrollmentprivileges_url
    assert_response :success
  end

end
