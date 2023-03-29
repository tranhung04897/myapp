require "test_helper"

class OsiCasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @osi_ca = osi_cas(:one)
  end

  test "should get index" do
    get osi_cas_url
    assert_response :success
  end

  test "should get new" do
    get new_osi_ca_url
    assert_response :success
  end

  test "should create osi_ca" do
    assert_difference("OsiCa.count") do
      post osi_cas_url, params: { osi_ca: { code: @osi_ca.code, name: @osi_ca.name, syntax_osi: @osi_ca.syntax_osi } }
    end

    assert_redirected_to osi_ca_url(OsiCa.last)
  end

  test "should show osi_ca" do
    get osi_ca_url(@osi_ca)
    assert_response :success
  end

  test "should get edit" do
    get edit_osi_ca_url(@osi_ca)
    assert_response :success
  end

  test "should update osi_ca" do
    patch osi_ca_url(@osi_ca), params: { osi_ca: { code: @osi_ca.code, name: @osi_ca.name, syntax_osi: @osi_ca.syntax_osi } }
    assert_redirected_to osi_ca_url(@osi_ca)
  end

  test "should destroy osi_ca" do
    assert_difference("OsiCa.count", -1) do
      delete osi_ca_url(@osi_ca)
    end

    assert_redirected_to osi_cas_url
  end
end
