require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "Should create user" do
    assert_difference('User.count') do
      post api_v1_users_url, params: { user: { email: "test@test.org", password: "123456" } }, as: :json
    end
    assert_response :created
  end

  test "Should not create user with taken email" do
    assert_no_difference('User.count') do
      post api_v1_users_url, params: { user: { email: @user.email, password: "123456" } }, as: :json
    end
    assert_response :unprocessable_entity
  end

  test "Should update user" do
    patch api_v1_user_url(@user), 
          params: { user: { email: @user.email } },
          headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
          as: :json
    assert_response :success
  end

  test "Should forbid update user" do
    patch api_v1_tokens_url(@user),
          params: { user: {email: @user.email } }

  end

  test "Should not update user when invalid params are sent" do
    patch api_v1_user_url(@user), params: { user: { email: "test", password: "123456" } }, headers: { Authorization: JsonWebToken.encode(user_id: @user.id) }, as: :json
    assert_response :unprocessable_entity
  end

  test "Should show user" do
    get api_v1_user_url(@user), as: :json
    assert_response :success
    json_response = JSON.parse(self.response.body, symbolize_names: true)
    assert_equal @user.email, json_response.dig(:data, :attributes, :email)
    assert_equal @user.products.first.id.to_s, json_response.dig(:data, :relationships, :products, :data, 0, :id)
    assert_equal @user.products.first.title, json_response.dig(:included, 0, :attributes, :title)
  end

  test "Should destroy user" do
    assert_difference('User.count', -1) do
      delete api_v1_user_url(@user),
      headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
      as: :json
    end
    assert_response :no_content
  end

  test "Should forbid destroy user" do
    assert_no_difference "User.count" do
      delete api_v1_user_url(@user), as: :json
    end
    assert_response :forbidden
  end

  test "destroy user should destroy linked products" do
    assert_difference("Product.count", -1) do
      users(:one).destroy
    end
  end
end
