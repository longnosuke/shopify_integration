# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :client

  validates :shopify_order_id, presence: true, uniqueness: true
  validates :order_number, presence: true
  validates :total_price, presence: true
  validates :status, presence: true

  scope :pending, -> { where(status: 'pending') }
  scope :processed, -> { where(status: 'processed') }
  scope :failed, -> { where(status: 'failed') }

  def processed!
    update!(status: 'processed')
  end

  def failed!
    update!(status: 'failed')
  end

  def pending?
    status == 'pending'
  end

  def processed?
    status == 'processed'
  end

  def failed?
    status == 'failed'
  end
end
