require 'test_helper'



class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
  end

  test "should get index" do
    get users_path
    assert_response :success
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

end
