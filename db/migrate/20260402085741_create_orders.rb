class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :client, null: false, foreign_key: true
      t.string :shopify_order_id, null: false
      t.string :order_number, null: false
      t.decimal :total_price, precision: 10, scale: 2, null: false
      t.string :status, null: false, default: 'pending'
      t.json :payload

      t.timestamps
    end
    add_index :orders, :shopify_order_id, unique: true
    add_index :orders, :status
  end
end
