class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
    # Utilize the ShopifyApp::WebhookVerification concern to automatically verify the HMAC
    include ShopifyApp::WebhookVerification

    def orders_create
      order_data = params.to_h
      shop_domain = request.headers["Shopify-Shop-Domain"]

      # 1. Find merchant
      client = Client.find_by(shopify_domain: shop_domain)

      if client
        # Push into Job to prevent traffic jam
        ProcessOrderJob.perform_later(client_id: client.id, order_data: order_data)

        # Return 200 OK immediately to Shopify
        head :ok
      else
        head :not_found
      end
  end
end
