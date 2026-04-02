# frozen_string_literal: true

class ProcessOrderJob < ApplicationJob
  queue_as :default

  def perform(client_id:, order_data:)
    client = Client.find(client_id)

    order_items = order_data["line_items"]
    
    Rails.logger.info "Processing order data: #{order_data.keys}"

    # Calculate total from line items if total_price is not available
    total_price = order_data["total_price"] || begin
      if order_items
        order_items.sum { |item| item["line_price"].to_f }
      else
        0.0
      end
    end

    order = Order.create!(
      client: client,
      shopify_order_id: order_data["id"],
      order_number: order_data["name"] || order_data["id"],
      total_price: total_price,
      status: "pending",
      payload: order_data
    )
    
    Rails.logger.info "Order created successfully: #{order.id}"
  end
end
