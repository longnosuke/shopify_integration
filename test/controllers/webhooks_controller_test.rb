require "test_helper"

class WebhooksControllerTest < ActionDispatch::IntegrationTest
  test "should get shopify" do
    get webhooks_shopify_url
    assert_response :success
  end
end
