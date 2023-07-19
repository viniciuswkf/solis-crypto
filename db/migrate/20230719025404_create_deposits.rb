class CreateDeposits < ActiveRecord::Migration[7.0]
  def change
    create_table :deposits do |t|
      t.integer :amount
      t.json :pricing
      t.json :addresses
      t.integer :user_id
      t.string :status

      t.timestamps
    end
  end
end
