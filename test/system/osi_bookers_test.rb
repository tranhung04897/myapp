require "application_system_test_case"

class OsiBookersTest < ApplicationSystemTestCase
  setup do
    @osi_booker = osi_bookers(:one)
  end

  test "visiting the index" do
    visit osi_bookers_url
    assert_selector "h1", text: "Osi bookers"
  end

  test "should create osi booker" do
    visit osi_bookers_url
    click_on "New osi booker"

    fill_in "Code", with: @osi_booker.code
    fill_in "Name", with: @osi_booker.name
    fill_in "Syntax osi", with: @osi_booker.syntax_osi
    click_on "Create Osi booker"

    assert_text "Osi booker was successfully created"
    click_on "Back"
  end

  test "should update Osi booker" do
    visit osi_booker_url(@osi_booker)
    click_on "Edit this osi booker", match: :first

    fill_in "Code", with: @osi_booker.code
    fill_in "Name", with: @osi_booker.name
    fill_in "Syntax osi", with: @osi_booker.syntax_osi
    click_on "Update Osi booker"

    assert_text "Osi booker was successfully updated"
    click_on "Back"
  end

  test "should destroy Osi booker" do
    visit osi_booker_url(@osi_booker)
    click_on "Destroy this osi booker", match: :first

    assert_text "Osi booker was successfully destroyed"
  end
end
