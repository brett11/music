require 'test_helper'

class ConcertsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @concertOne = concerts(:concertOne)
    @concertTwo = concerts(:concertTwo)
  end

  test "should get index" do
    get concerts_path
    assert_response :success
  end

  test "should get show" do
    get concert_path(@concertOne)
    assert_response :success
  end
end
