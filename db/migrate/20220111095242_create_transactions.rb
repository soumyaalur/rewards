class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :payer, null: false, foreign_key: true
      t.integer :points
      t.datetime :transaction_time

      t.timestamps
    end
    add_index :transactions, :transaction_time
  end
end
