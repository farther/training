class CreteBankimate < ActiveRecord::Migration
  def change
    create_table :banknotes do |t|
      t.integer :account_id

      t.integer  :denomination, default: 0, null: false
      t.string :title
      t.text :description
      t.boolean :blocked, default: false, null: false
      t.timestamps null: false
    end
  end
end
