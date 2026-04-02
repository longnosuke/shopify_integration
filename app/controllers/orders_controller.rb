class OrdersController < ApplicationController
  def index
    @orders = Order.includes(:client).order(created_at: :desc)
  end

  def show
    @order = Order.includes(:client).find(params[:id])
  end
end
