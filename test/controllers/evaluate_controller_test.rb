require 'test_helper'

class EvaluateControllerTest < ActionDispatch::IntegrationTest
  test "should get evaluation" do
    get evaluate_evaluation_url
    assert_response :success
  end

end
