require 'test_helper'

class PaymentNotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payment_notification = payment_notifications(:one)
  end

  test "should get index" do
    get payment_notifications_url
    assert_response :success
  end

  test "should get new" do
    get new_payment_notification_url
    assert_response :success
  end

  test "should create payment_notification" do
    assert_difference('PaymentNotification.count') do
      post payment_notifications_url, params: { payment_notification: {  } }
    end

    assert_redirected_to payment_notification_url(PaymentNotification.last)
  end

  test "should show payment_notification" do
    get payment_notification_url(@payment_notification)
    assert_response :success
  end

  test "should get edit" do
    get edit_payment_notification_url(@payment_notification)
    assert_response :success
  end

  test "should update payment_notification" do
    patch payment_notification_url(@payment_notification), params: { payment_notification: {  } }
    assert_redirected_to payment_notification_url(@payment_notification)
  end

  test "should destroy payment_notification" do
    assert_difference('PaymentNotification.count', -1) do
      delete payment_notification_url(@payment_notification)
    end

    assert_redirected_to payment_notifications_url
  end
end
