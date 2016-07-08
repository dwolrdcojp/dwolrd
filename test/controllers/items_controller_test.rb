require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @item = items(:one)
    @item2 = items(:two)
    @user = users(:one)
  end

  test "should get index" do
    get items_url
    assert_response :success
  end

  test "should get new" do
    sign_in @user
    get new_item_url
    assert_response :success
  end

  test "should create item" do
    sign_in @user
    assert_difference('Item.count') do
      post items_url, params: { item: { content: @item.content, title: @item.title } }
    end

    assert_redirected_to item_url(Item.last)
  end

  test "should show item" do
    get item_url(@item)
    assert_response :success
  end

  test "should get edit" do
    sign_in @user
    get edit_item_url(@item)
    assert_response :success
  end

  test "should update item" do
    sign_in @user
    patch item_url(@item), params: { item: { title: "A new title", 
                                             content: "Some content foo" } }
    @item.reload
    assert_equal "A new title", @item.title
  end

  test "should destroy item" do
    sign_in @user
    assert_difference('Item.count', -1) do
      delete item_url(@item)
    end

    assert_redirected_to items_url
  end
end
