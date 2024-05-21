require "test_helper"

class ShelvesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shelf = shelves(:one)
  end

  test "should get index" do
    get shelves_url, as: :json
    assert_response :success
  end

  test "should create shelf" do
    assert_difference("Shelf.count") do
      post shelves_url, params: { shelf: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show shelf" do
    get shelf_url(@shelf), as: :json
    assert_response :success
  end

  test "should update shelf" do
    patch shelf_url(@shelf), params: { shelf: {  } }, as: :json
    assert_response :success
  end

  test "should destroy shelf" do
    assert_difference("Shelf.count", -1) do
      delete shelf_url(@shelf), as: :json
    end

    assert_response :no_content
  end
end
