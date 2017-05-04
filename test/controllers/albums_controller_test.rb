require 'test_helper'

class AlbumsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @thriller = albums(:thriller)
    @joshuaTree = albums(:joshuaTree)
  end

  test "should get index" do
    get albums_path
    assert_response :success
  end

  test "should get show" do
    get album_path(@joshuaTree)
    assert_response :success
  end
end
