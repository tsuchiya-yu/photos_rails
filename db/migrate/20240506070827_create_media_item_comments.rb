class CreateMediaItemComments < ActiveRecord::Migration[7.1]
  def change
    create_table :media_item_comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :media_item, null: false, foreign_key: true
      t.string :comment, null: false

      t.timestamps
    end
  end
end
