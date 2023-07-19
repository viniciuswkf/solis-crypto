require "test_helper"

class DepositsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deposit = deposits(:one)
  end

  test "should get index" do
    get deposits_url, as: :json
    assert_response :success
  end

  test "should create deposit" do
    assert_difference("Deposit.count") do
      post deposits_url, params: { deposit: { addresses: @deposit.addresses, amount: @deposit.amount, pricing: @deposit.pricing, status: @deposit.status, user_id: @deposit.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show deposit" do
    get deposit_url(@deposit), as: :json
    assert_response :success
  end

  test "should update deposit" do
    patch deposit_url(@deposit), params: { deposit: { addresses: @deposit.addresses, amount: @deposit.amount, pricing: @deposit.pricing, status: @deposit.status, user_id: @deposit.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy deposit" do
    assert_difference("Deposit.count", -1) do
      delete deposit_url(@deposit), as: :json
    end

    assert_response :no_content
  end
end
