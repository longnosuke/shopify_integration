# frozen_string_literal: true

class ProcessOrderJob < ApplicationJob
  queue_as :default

  def perform(client_id:, order_data:)
    client = Client.find(client_id)

    order_items = order_data["line_items"]

    pending_order = PendingOrder.create!(
      client: client,
      shopify_order_id: order_data["id"],
      order_number: order_data["name"],
      total_price: order_data["total_price"],
      status: "pending",
      payload: order_data
    )
  end
end
