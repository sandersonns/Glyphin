require "test_helper"

class GlyphsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get glyphs_index_url
    assert_response :success
  end

  test "should get show" do
    get glyphs_show_url
    assert_response :success
  end

  test "should get new" do
    get glyphs_new_url
    assert_response :success
  end

  test "should get edit" do
    get glyphs_edit_url
    assert_response :success
  end

  test "should get create" do
    get glyphs_create_url
    assert_response :success
  end

  test "should get update" do
    get glyphs_update_url
    assert_response :success
  end

  test "should get destroy" do
    get glyphs_destroy_url
    assert_response :success
  end
end
