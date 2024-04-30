class CreateGroupMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :group_members do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.boolean :is_master, null: false, default: false

      t.timestamps
    end
  end
end
