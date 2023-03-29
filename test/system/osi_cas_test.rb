require "application_system_test_case"

class OsiCasTest < ApplicationSystemTestCase
  setup do
    @osi_ca = osi_cas(:one)
  end

  test "visiting the index" do
    visit osi_cas_url
    assert_selector "h1", text: "Osi cas"
  end

  test "should create osi ca" do
    visit osi_cas_url
    click_on "New osi ca"

    fill_in "Code", with: @osi_ca.code
    fill_in "Name", with: @osi_ca.name
    fill_in "Syntax osi", with: @osi_ca.syntax_osi
    click_on "Create Osi ca"

    assert_text "Osi ca was successfully created"
    click_on "Back"
  end

  test "should update Osi ca" do
    visit osi_ca_url(@osi_ca)
    click_on "Edit this osi ca", match: :first

    fill_in "Code", with: @osi_ca.code
    fill_in "Name", with: @osi_ca.name
    fill_in "Syntax osi", with: @osi_ca.syntax_osi
    click_on "Update Osi ca"

    assert_text "Osi ca was successfully updated"
    click_on "Back"
  end

  test "should destroy Osi ca" do
    visit osi_ca_url(@osi_ca)
    click_on "Destroy this osi ca", match: :first

    assert_text "Osi ca was successfully destroyed"
  end
end
