class CreteAccount < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string   :number
      t.integer   :used_id
      t.boolean :blocked, default: false, null: false

      t.timestamps null: false
    end
  end
end
