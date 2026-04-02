class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
    # Use Concern của Shopify App để tự động xác thực HMAC
    include ShopifyApp::WebhookVerification

    def orders_create
      order_data = params.to_h
      shop_domain = request.headers["Shopify-Shop-Domain"]

      # 1. Tìm Merchant trong hệ thống
      client = Client.find_by(shopify_domain: shop_domain)

      if client
        # 2. Đẩy vào Background Job để xử lý (Tránh làm chậm response của Webhook)
        ProcessOrderJob.perform_later(client_id: client.id, order_data: order_data)

        # Trả về 200 OK ngay lập tức cho Shopify
        head :ok
      else
        head :not_found
      end
  end
end
