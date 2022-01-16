class CreatePayers < ActiveRecord::Migration[6.0]
  def change
    create_table :payers do |t|
      t.string :name

      t.timestamps
    end
    add_index :payers, :name, unique: true
  end
end
