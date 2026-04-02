class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def orders_create
    begin
      raw_body = request.body.read
      request.body.rewind
      order_data = JSON.parse(raw_body)
      shop_domain = request.headers["X-Shopify-Shop-Domain"]
      webhook_topic = request.headers["X-Shopify-Topic"]
      
      Rails.logger.info "Webhook topic: #{webhook_topic}"
      Rails.logger.info "Shop domain: #{shop_domain}"
      Rails.logger.info "Payload keys: #{order_data.keys}"

      client = Client.find_by(shopify_domain: shop_domain)

      if client
        ProcessOrderJob.perform_later(client_id: client.id, order_data: order_data)
        head :ok
      else
        Rails.logger.warn "Client not found for shop domain: #{shop_domain}"
        head :not_found
      end

    rescue JSON::ParserError => e
      Rails.logger.error "JSON parsing error: #{e.message}"
      render json: { error: "Invalid JSON" }, status: :bad_request

    rescue => e
      Rails.logger.error "Webhook processing error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { error: "Internal server error" }, status: :internal_server_error
    end
  end
end
