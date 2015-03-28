require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get get_page" do
    get :get_page
    assert_response :success
  end

end
