require "test_helper"

class ReceiptsControllerTest < ActionDispatch::IntegrationTest
  test "should get process" do
    get receipts_process_url
    assert_response :success
  end

  test "should get points" do
    get receipts_points_url
    assert_response :success
  end
end
