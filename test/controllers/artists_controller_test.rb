require 'test_helper'

class ArtistsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @michaelJackson = artists(:michaelJackson)
    @u2 = artists(:u2)
  end

  test "should get index" do
    get artists_path
    assert_response :success
  end

  test "should get show" do
    get artist_path(@u2)
    assert_response :success
  end
end
