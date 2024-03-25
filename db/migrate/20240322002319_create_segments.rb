class CreateSegments < ActiveRecord::Migration[7.1]
  def change
    create_table :segments do |t|
      t.string :s_type, null: false
      t.string :format
      t.string :base_value, null: false
      t.string :value
      t.string :behavior
      t.string :reset
      t.integer :order, null: false, default: 1
      t.belongs_to :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end