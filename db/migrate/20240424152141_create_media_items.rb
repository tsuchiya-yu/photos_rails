class CreateMediaItems < ActiveRecord::Migration[7.1]
  def change
    create_table :media_items do |t|
      t.references :album, null: false, foreign_key: true
      t.text :description
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
