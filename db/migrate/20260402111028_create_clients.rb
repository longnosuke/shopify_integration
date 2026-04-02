class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients do |t|
      t.string :shopify_domain
      t.string :name
      t.string :shopify_token

      t.timestamps
    end
  end
end
