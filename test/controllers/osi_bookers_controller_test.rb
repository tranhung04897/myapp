require "test_helper"

class OsiBookersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @osi_booker = osi_bookers(:one)
  end

  test "should get index" do
    get osi_bookers_url
    assert_response :success
  end

  test "should get new" do
    get new_osi_booker_url
    assert_response :success
  end

  test "should create osi_booker" do
    assert_difference("OsiBooker.count") do
      post osi_bookers_url, params: { osi_booker: { code: @osi_booker.code, name: @osi_booker.name, syntax_osi: @osi_booker.syntax_osi } }
    end

    assert_redirected_to osi_booker_url(OsiBooker.last)
  end

  test "should show osi_booker" do
    get osi_booker_url(@osi_booker)
    assert_response :success
  end

  test "should get edit" do
    get edit_osi_booker_url(@osi_booker)
    assert_response :success
  end

  test "should update osi_booker" do
    patch osi_booker_url(@osi_booker), params: { osi_booker: { code: @osi_booker.code, name: @osi_booker.name, syntax_osi: @osi_booker.syntax_osi } }
    assert_redirected_to osi_booker_url(@osi_booker)
  end

  test "should destroy osi_booker" do
    assert_difference("OsiBooker.count", -1) do
      delete osi_booker_url(@osi_booker)
    end

    assert_redirected_to osi_bookers_url
  end
end
