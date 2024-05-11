class CreateAlbums < ActiveRecord::Migration[7.1]
  def change
    create_table :albums do |t|
      t.references :group, null: false, foreign_key: true
      t.string :name, null: false
      t.string :catchphrase
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
