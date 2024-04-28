class CreateGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :groups do |t|
      t.string :catchphrase
      t.string :name, null: false
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :groups, :deleted_at
  end
end
