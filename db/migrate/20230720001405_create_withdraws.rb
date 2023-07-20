class CreateWithdraws < ActiveRecord::Migration[7.0]
  def change
    create_table :withdraws do |t|
      t.integer :amount
      t.string :status
      t.string :payment_method
      t.string :payment_method_target
      t.integer :user_id

      t.timestamps
    end
  end
end
