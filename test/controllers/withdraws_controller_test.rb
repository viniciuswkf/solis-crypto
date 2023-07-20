require "test_helper"

class WithdrawsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @withdraw = withdraws(:one)
  end

  test "should get index" do
    get withdraws_url, as: :json
    assert_response :success
  end

  test "should create withdraw" do
    assert_difference("Withdraw.count") do
      post withdraws_url, params: { withdraw: { amount: @withdraw.amount, payment_method: @withdraw.payment_method, payment_method_target: @withdraw.payment_method_target, status: @withdraw.status, user_id: @withdraw.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show withdraw" do
    get withdraw_url(@withdraw), as: :json
    assert_response :success
  end

  test "should update withdraw" do
    patch withdraw_url(@withdraw), params: { withdraw: { amount: @withdraw.amount, payment_method: @withdraw.payment_method, payment_method_target: @withdraw.payment_method_target, status: @withdraw.status, user_id: @withdraw.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy withdraw" do
    assert_difference("Withdraw.count", -1) do
      delete withdraw_url(@withdraw), as: :json
    end

    assert_response :no_content
  end
end
