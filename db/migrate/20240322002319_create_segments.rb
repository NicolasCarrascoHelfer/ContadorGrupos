class CreateSegments < ActiveRecord::Migration[7.1]
  def change
    create_table :segments do |t|
      t.integer :category, null: false
      t.string :format
      t.string :base_value, null: false
      t.string :value
      t.integer :behavior
      t.integer :reset
      t.integer :position, null: false, default: 1
      t.belongs_to :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
