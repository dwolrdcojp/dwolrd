require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "D-WOLRD: POWER SHOP"
  end

  test "should get root" do
    get root_path
    assert_response :success
    assert_select "title", " | #{@base_title}"
  end

  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

end